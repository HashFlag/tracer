from django import template
from app01 import models
from django.urls import reverse
register = template.Library()


@register.inclusion_tag('inclusion/all_project_list.html')
def all_project_list(request):
    # 获取当前用户创建的项目
    my_project_list = models.Project.objects.filter(
        creator=request.tracer_obj.user_obj
    )
    # 当前用户参与的项目
    join_project_list = models.ProjectUser.objects.filter(
        user=request.tracer_obj.user_obj
    )
    return {'my': my_project_list, 'join': join_project_list, 'request': request}


@register.inclusion_tag('inclusion/manage_menu_list.html')
def manage_menu_list(request):
    path = request.tracer_obj.project.id
    data_list = [
        {'title': '概览', 'url': reverse('app01:dashboard', kwargs={'pro_id': path})},
        {'title': '问题', 'url': reverse('app01:issues', kwargs={'pro_id': path})},
        {'title': '统计', 'url': reverse('app01:statistics', kwargs={'pro_id': path})},
        {'title': 'wiki', 'url': reverse('app01:wiki', kwargs={'pro_id': path})},
        {'title': '文件', 'url': reverse('app01:file', kwargs={'pro_id': path})},
        {'title': '配置', 'url': reverse('app01:setting', kwargs={'pro_id': path})},
    ]
    for i in data_list:
        if request.path == i.get('url'):
            i['class'] = "class-active"
    return {'data_list': data_list}






