import json
import uuid
from django import views
from django.shortcuts import render, redirect, HttpResponse
from app01.myform import project
from app01 import models
from libs.aliyun.oss import create_bucket


class ProjectList(views.View):
    """ 个人项目中心 """
    def get(self, request):
        form = project.ProjectModelForm(request)
        project_dict = {'my': [], 'join': [], 'star': []}
        # todo 计算项目参与人数
        my_project_list = models.Project.objects.filter(creator=request.tracer_obj.user_obj)
        for my_p in my_project_list:
            if my_p.star:
                project_dict['star'].append({'star_type': 'my', 'value': my_p})
            else:
                project_dict['my'].append(my_p)

        join_project_list = models.ProjectUser.objects.filter(user=request.tracer_obj.user_obj)
        for join_p in join_project_list:
            if join_p.star:
                project_dict['star'].append({'star_type': 'join', 'value': join_p.project})
            else:
                project_dict['join'].append(join_p.project)
        # print(project_dict['join'])
        return render(request, "app01/project_list.html", {'form': form, 'project_dict': project_dict})

    def post(self, request):
        form = project.ProjectModelForm(request, request.POST)
        data = {'status': False, 'error_msg': ''}
        if form.is_valid():
            # form.instance是保存前的model对象，可以给他添加数据
            bucket_name = "{}-827{}".format(
                uuid.uuid4(),
                request.tracer_obj.user_obj.id)
            create_bucket(bucket_name)
            form.instance.creator = request.tracer_obj.user_obj
            form.instance.bucket = bucket_name
            form.instance.region = "cn-beijing"
            instance = form.save()
            # 保存问题类型
            issues_list = []
            for item in models.IssuesType.PROJECT_INIT_LIST:
                issues_list.append(
                    models.IssuesType(
                        title=item,
                        project=instance,
                    )
                )
            models.IssuesType.objects.bulk_create(issues_list)  # 批量创建数据
            data['status'] = True
            return HttpResponse(json.dumps(data))
        else:
            data['error_msg'] = form.errors
            return HttpResponse(json.dumps(data))


def project_star(request, star_type, pid):
    """ 添加星标 """
    if star_type == 'my':
        models.Project.objects.filter(id=pid, creator=request.tracer_obj.user_obj).update(star=True)
        return redirect('app01:project_list')
    else:
        models.ProjectUser.objects.filter(
            project_id=pid,
            user=request.tracer_obj.user_obj
        ).update(star=True)
        return redirect('app01:project_list')


def project_unstar(request, start_type, pid):
    """ 移除星标 """
    if start_type == 'my':
        models.Project.objects.filter(id=pid, creator=request.tracer_obj.user_obj).update(star=False)
        return redirect('app01:project_list')

    else:
        models.ProjectUser.objects.filter(
            project_id=pid,
            user=request.tracer_obj.user_obj
        ).update(star=False)
        return redirect('app01:project_list')








