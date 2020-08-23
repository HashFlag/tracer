from django import views
from app01 import models
from django.shortcuts import render
from django.http import JsonResponse
from app01.myform.issues import IssuesModelForm
from utils.pagination import Pagination
from django.conf import settings


class Issues(views.View):
    """ 问题管理 """
    def get(self, request, pro_id):
        form = IssuesModelForm(request)
        current_page = request.GET.get('page')
        queryset = models.Issues.objects.filter(
            project=request.tracer_obj.project
        )
        page_obj = Pagination(
            current_page=current_page,  # 当前页数
            all_count=queryset.count(),  # 数据库中总条数
            base_url=request.path,  # 不带参数的基础路径
            query_params=request.GET,
            per_page=settings.PER_PAGE,  # 默认显示条数
            pager_page_count=settings.PAGER_PAGE_COUNT  # 页面上最多显示的页码数量
        )
        issues_object_list = queryset[page_obj.start:page_obj.end]
        content = {
            'form': form,
            'issues_object_list': issues_object_list,
            'page_obj': page_obj,
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
                # 'datetime': row.create_datetime.strftime('%Y-%m-%d %H:%M'),
                'datetime': row.create_datetime,
                'parent_id': row.reply_id

            }
            data_list.append(data)
        return JsonResponse({'status': True, 'data': data_list})










