import json
import datetime
from django import views
from app01 import models
from utils.enc import uid
from django.urls import reverse
from django.conf import settings
from django.db import transaction
from django.shortcuts import render
from django.http import JsonResponse
from utils.pagination import Pagination
from django.utils.safestring import mark_safe
from django.views.decorators.csrf import csrf_exempt
from app01.myform.issues import IssuesModelForm, IssuesReplyModelForm, InviteModelForm


class CheckFilter:

    def __init__(self, name, data_list, request):
        self.name = name  # status,issues_type
        self.data_list = data_list  # [(1, 'bug'),(2, '任务')]
        self.request = request  # request对象

    def __iter__(self):
        for item in self.data_list:
            key = str(item[0])  # '1'
            text = item[1]  # '任务'
            value_list = self.request.GET.getlist(self.name)  # [3, ]
            checked = ''
            if key in value_list:
                checked = 'checked'
                value_list.remove(key)
            else:
                value_list.append(key)
            query_dict = self.request.GET.copy()  # ?status=2&status=3
            query_dict._mutable = True
            query_dict.setlist(self.name, value_list)  # status=2 status=3 & issues_type=1
            if 'page' in query_dict:
                query_dict.pop('page')

            # print(query_dict)
            params = query_dict.urlencode()  # status=2&status=3
            # print(query_dict.urlencode())
            current_path = self.request.path
            url = '{}?{}'.format(current_path, params)
            html = '<a href="{url}"><input type="checkbox" {ck}> {name}</a>'
            html = html.format(url=url, ck=checked, name=text)
            yield mark_safe(html)


class SelectFilter:

    def __init__(self, name, data_list, request):
        self.name = name  # status,issues_type
        self.data_list = data_list  # [(1, 'bug'),(2, '任务')]
        self.request = request  # request对象

    def __iter__(self):
        yield mark_safe('<select multiple="multiple" style="width: 100%;" class="select2 hide">')
        for item in self.data_list:
            key = str(item[0])  # '1'
            text = item[1]  # '任务'
            value_list = self.request.GET.getlist(self.name)  # [3, ]
            selected = ''
            if key in value_list:
                selected = 'selected'
                value_list.remove(key)
            else:
                value_list.append(key)

            query_dict = self.request.GET.copy()  # ?status=2&status=3
            query_dict._mutable = True

            query_dict.setlist(self.name, value_list)  # status=2 status=3 & issues_type=1
            if 'page' in query_dict:
                query_dict.pop('page')
            # print(query_dict)
            params = query_dict.urlencode()  # status=2&status=3
            # print(query_dict.urlencode())
            current_path = self.request.path
            url = '{}?{}'.format(current_path, params)
            html = '<option value="{url}" {ck}>{name}</option>'
            html = html.format(url=url, ck=selected, name=text)
            yield mark_safe(html)
        yield mark_safe('</select>')


class Issues(views.View):
    """ 问题管理 """
    def get(self, request, pro_id):

        allow_filter_name = ['issues_type', 'status', 'assign', 'attention', 'priority']
        condition = {}
        for name in allow_filter_name:
            value_list = request.GET.getlist(name)
            if not value_list:
                continue
            condition['{}__in'.format(name)] = value_list

        form = IssuesModelForm(request)
        current_page = request.GET.get('page')
        queryset = models.Issues.objects.filter(
            project=request.tracer_obj.project
        ).filter(**condition)
        page_obj = Pagination(
            current_page=current_page,  # 当前页数
            all_count=queryset.count(),  # 数据库中总条数
            base_url=request.path,  # 不带参数的基础路径
            query_params=request.GET,
            per_page=settings.PER_PAGE,  # 默认显示条数
            pager_page_count=settings.PAGER_PAGE_COUNT  # 页面上最多显示的页码数量
        )
        issues_object_list = queryset[page_obj.start:page_obj.end]

        project_issues_type = models.IssuesType.objects.filter(project_id=pro_id).values_list(
            'id', 'title')  # [(1, 'bug')]
        # 所有参与人(创建者、参与者)
        project_total_user = [
            (request.tracer_obj.project.creator.id, request.tracer_obj.project.creator.username),
        ]
        join_user = models.ProjectUser.objects.filter(project_id=pro_id).values_list('id', 'user__username')
        project_total_user.extend(join_user)

        invite_form = InviteModelForm()
        content = {
            'form': form,
            'issues_object_list': issues_object_list,
            'page_obj': page_obj,
            'invite_form': invite_form,
            'filter_list': [
                {'title': '问题类型', 'filter': CheckFilter('issues_type', project_issues_type, request)},

                {'title': '状态', 'filter': CheckFilter('status', models.Issues.status_choices, request)},  # ((1,'新建'),)

                {'title': '优先级', 'filter': CheckFilter('priority', models.Issues.priority_choices, request)},

                {'title': '指派者', 'filter': SelectFilter('assign', project_total_user, request)},

                {'title': '关注者', 'filter': SelectFilter('attention', project_total_user, request)},

            ]
        }
        return render(request, "app01/issues.html", content)

    def post(self, request, pro_id):
        form = IssuesModelForm(request, data=request.POST)
        if form.is_valid():
            form.instance.project = request.tracer_obj.project
            form.instance.creator = request.tracer_obj.user_obj
            form.save()

            return JsonResponse({'status': True})
        else:

            return JsonResponse({'status': False, 'error': form.errors})


class IssuesDetail(views.View):
    """ 问题详情页面 """
    def get(self, request, pro_id, issues_id):
        issues_obj = models.Issues.objects.filter(project_id=pro_id, id=issues_id).first()
        form = IssuesModelForm(request, instance=issues_obj)
        return render(request, "app01/issues_detail.html", {"form": form, 'issues_obj': issues_obj})


class IssuesRecord(views.View):
    """ 评论展示页面 """
    def get(self, request, pro_id, issues_id):
        reply_list = models.IssuesReply.objects.filter(
            issues_id=issues_id,
            issues__project_id=pro_id,  # 找到哪个项目的问题
        )
        data_list = []
        for row in reply_list:
            data = {
                'id': row.id,
                'reply_type_text': row.get_reply_type_display(),
                'content': row.content,
                'creator': row.creator.username,
                'datetime': row.create_datetime.strftime('%Y-%m-%d %H:%M'),
                # 'datetime': row.create_datetime,
                'parent_id': row.reply_id
            }
            data_list.append(data)
        return JsonResponse({'status': True, 'data': data_list})

    def post(self, request, pro_id, issues_id):
        form = IssuesReplyModelForm(request.POST)
        if form.is_valid():
            form.instance.issues_id = issues_id
            form.instance.reply_type = 2
            form.instance.creator = request.tracer_obj.user_obj
            instance = form.save()
            info = {
                'id': instance.id,
                'reply_type_text': instance.get_reply_type_display(),
                'content': instance.content,
                'creator': instance.creator.username,
                'datetime': instance.create_datetime.strftime('%Y-%m-%d %H:%M'),
                # 'datetime': instance.create_datetime,
                'parent_id': instance.reply_id
            }
            return JsonResponse({'status': True, 'data': info})
        else:
            return JsonResponse({'status': False, 'error': form.errors})


@csrf_exempt
def issues_change(request, pro_id, issues_id):
    """ 问题实时修改 """
    issues_obj = models.Issues.objects.filter(id=issues_id, project_id=pro_id).first()
    post_dict = json.loads(request.body.decode('utf-8'))
    name = post_dict.get('name')  # 拿到字段名称
    value = post_dict.get('value')  # 拿到对应字段改后的值
    print(name, value)
    field_obj = models.Issues._meta.get_field(name)  # 获取字段的实例化对象

    # 实时添加修改记录
    def create_reply_record(change_record):
        # 保存一条更新记录到issuesreply表中
        new_obj = models.IssuesReply.objects.create(
            reply_type=1,
            issues=issues_obj,
            content=change_record,
            creator=request.tracer_obj.user_obj,
        )
        # 生成返回数据，供前端使用
        info = {
            'id': new_obj.id,
            'reply_type_text': new_obj.get_reply_type_display(),
            'content': new_obj.content,
            'creator': new_obj.creator.username,
            'datetime': new_obj.create_datetime.strftime('%Y-%m-%d %H:%M'),
            # 'datetime': instance.create_datetime,
            'parent_id': new_obj.reply_id
        }
        return info

    # 验证字段
    # 文本验证
    if name in ['subject', 'desc', 'start_date', 'end_date']:
        # 字段不能为空时，该字段必须传过来数据
        if not value:
            if not field_obj.null:
                return JsonResponse({'status': False, 'error': '该值不能为空，请插入点东西'})
            setattr(issues_obj, name, None)
            issues_obj.save()
            change_record = '{}更新为空'.format(field_obj.verbose_name)
            info = create_reply_record(change_record)
            return JsonResponse({'status': True, 'data': info})
        else:
            setattr(issues_obj, name, value)
            issues_obj.save()
            change_record = '{}更新为{}'.format(field_obj.verbose_name, value)
            info = create_reply_record(change_record)
            return JsonResponse({'status': True, 'data': info})

    # foreignkey 外键字段验证
    if name in ['issues_type', 'module', 'parent', 'assign']:
        # 字段不能为空时，该字段必须传过来数据
        if not value.strip():
            if not field_obj.null:
                return JsonResponse({'status': False, 'error': '该值不能为空，请插入点东西'})
            setattr(issues_obj, name, None)
            issues_obj.save()
            change_record = '{}更新为空'.format(field_obj.verbose_name)
            info = create_reply_record(change_record)
            return JsonResponse({'status': True, 'data': info})

        else:
            # 是项目创建者还是参与者
            if name == 'assign':
                if value == str(request.tracer_obj.project.creator_id):
                    user_obj = request.tracer_obj.project.creator
                else:
                    instance = models.ProjectUser.objects.filter(
                        project_id=pro_id,
                        user_id=value
                    ).first()
                    if instance:
                        user_obj = instance
                    else:
                        user_obj = None

                if not user_obj:
                    return JsonResponse({'status': False, 'error': '别乱选，查无此人！'})

                setattr(issues_obj, name, user_obj)  # assign
                issues_obj.save()
                change_record = '{}更新为{}'.format(field_obj.verbose_name, str(user_obj))

                info = create_reply_record(change_record)
                return JsonResponse({'status': True, 'data': info})
            else:
                instance = field_obj.rel.model.objects.filter(
                    id=value,
                    project_id=pro_id,
                ).first()
                if not instance:
                    return JsonResponse({'status': False, 'error': '该选项不存在'})

                setattr(issues_obj, name, instance)  # assign
                issues_obj.save()
                change_record = '{}更新为{}'.format(field_obj.verbose_name, str(instance))

                info = create_reply_record(change_record)
                return JsonResponse({'status': True, 'data': info})

    # choice选择验证
    if name in ['priority', 'status', 'mode']:
        select_text = None
        for key, text in field_obj.choices:
            if str(key) == value:
                select_text = text
        if not select_text:
            return JsonResponse({'status': False, 'error': '该选项不存在'})
        setattr(issues_obj, name, value)  # assign
        issues_obj.save()
        change_record = '{}更新为{}'.format(field_obj.verbose_name,select_text)

        info = create_reply_record(change_record)
        return JsonResponse({'status': True, 'data': info})

    # ManyToMany多表验证
    if name == 'attention':
        # {name:'attention', value:[1,2,3]}

        if not isinstance(value, list):
            return JsonResponse({'status': False, 'error': '数据格式有误'})
        if not value:
            # issues_obj.attention.clear()
            # issues_obj.attention.set([])
            issues_obj.attention.set(value)
            issues_obj.save()
            change_record = '{}更新为空'.format(field_obj.verbose_name)

            info = create_reply_record(change_record)
            return JsonResponse({'status': True, 'data': info})
        else:
            # [1,2] --  [1, 2, 3 ,4]
            # 创建者 + 项目参与者
            user_dict = {
                # '1':'chao'
                str(request.tracer_obj.project.creator.id):request.tracer_obj.project.creator.username,

            }

            project_user = models.ProjectUser.objects.filter(
                project_id=pro_id,
            )
            for item in project_user:
                user_dict[str(item.user_id)] = item.user.username

            user_list = []  # 拿到所有选中的关注者名称，后面来生成变更记录时使用
            for user_id in value:
                username = user_dict.get(str(user_id))
                if not username:
                    return JsonResponse({'status': False, 'error': '找不到这个人！'})

                user_list.append(username)

            issues_obj.attention.set(value)  # clear()  add()
            issues_obj.save()
            change_record = '{}更新为{}'.format(field_obj.verbose_name, ','.join(user_list))

            info = create_reply_record(change_record)
            return JsonResponse({'status': True, 'data': info})

    return JsonResponse({'status': False, 'error': '输入有误！'})


def invite_url(request, pro_id):
    # 校验数据
    form = InviteModelForm(request.POST)
    if form.is_valid():
        # 只有项目创建者可以邀请别人，创建邀请码
        if request.tracer_obj.user_obj != request.tracer_obj.project.creator:
            form.add_error('period', '只有项目创建者才能生成邀请码！')
            return JsonResponse({'status': False, 'error': form.errors})

        # 生成邀请码  http://127.0.0.1:8000/invite_join/adlsjfoasvhoasgnsldjvoasjdgoi/
        code = uid(request.tracer_obj.user_obj.phone)
        # 保存数据
        form.instance.project = request.tracer_obj.project
        form.instance.creator = request.tracer_obj.project.creator
        form.instance.code = code
        form.save()

        url = '{xieyi}://{host}{path}'.format(
            xieyi=request.scheme,  # 当前请求协议
            host=request.get_host(),  # ip+端口号
            path=reverse('app01:invite_join', kwargs={"code": code})
        )
        return JsonResponse({'status': True, 'url': url})
    else:
        return JsonResponse({'status': False, 'error': form.errors})


def invite_join(request, code):
    """ 访问邀请链接 """
    current_datetime = datetime.datetime.now()
    # 邀请码对不对
    invite_obj = models.ProjectInvite.objects.filter(code=code).first()
    if not invite_obj:
        return render(request, 'app01/invite_join.html', {'error': '邀请码不存在'})

    # 如果是创建者了或者是参与者了，就不能再加入项目了
    if invite_obj.project.creator == request.tracer_obj.user_obj:
        return render(request, 'app01/invite_join.html', {'error': '创建者不需要加入该项目'})
    exists = models.ProjectUser.objects.filter(project=invite_obj.project, user=request.tracer_obj.user_obj).exists()
    if exists:
        return render(request, 'app01/invite_join.html', {'error': '参与者不需要加入该项目'})

    # 策略中的项目成员人数限制
    new_transaction = models.Transaction.objects.filter(user=request.tracer_obj.user_obj, status=2, ).order_by('-id').first()
    if new_transaction.price_policy.catogory == 1:
        # 免费版
        max_members = new_transaction.price_policy.project_member

    else:
        if new_transaction.end_datetime < current_datetime:
            free_obj = models.PricePolicy.objects.filter(catogory=1).first()
            max_members = free_obj.project_member
        else:
            max_members = new_transaction.price_policy.project_member

    # 项目成员人数限制
    current_members = models.ProjectUser.objects.filter(
        project=invite_obj.project,
    ).count()
    current_members += 1  # 加上项目创建者
    if current_members >= max_members:
        return render(request, 'app01/invite_join.html', {'error': '项目成员人数上限已到，该花钱了！'})

    # 邀请码有效期(是否过期了)
    limit_datetime = invite_obj.create_datetime + datetime.timedelta(minutes=invite_obj.period)   # 截止时间
    if current_datetime > limit_datetime:
        return render(request, 'app01/invite_join.html', {'error': '邀请码已经过期'})

    # 加事务
    with transaction.atomic():
        # sid = transaction.savepoint()
        # 邀请数量判断
        if invite_obj.count:
            if invite_obj.use_count >= invite_obj.count:
                # 这个地方涉及到了数据库操作
                return render(request, 'app01/invite_join.html', {'error': '邀请成员个数已到'})
            invite_obj.use_count += 1
            invite_obj.save()

        # 参与人那个表里面加一条记录
        models.ProjectUser.objects.create(
            user=request.tracer_obj.user_obj,
            project=invite_obj.project,
        )

        # 项目表里面那个参与成员人数要更新
        invite_obj.project.join_count += 1
        invite_obj.project.save()
        # transaction.savepoint_rollback(sid)
    return render(request, 'app01/invite_join.html')









