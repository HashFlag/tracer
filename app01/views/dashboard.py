import time
import datetime

from django import views
from app01 import models
from django.http import JsonResponse
from django.shortcuts import render
from collections import OrderedDict
from django.db.models import Count


class Dashboard(views.View):
    """ 概览 """
    def get(self, request, pro_id):
        # 问题状态数据
        # 分组：
        status_dict = OrderedDict()  # 有序字典
        for k, v in models.Issues.status_choices:
            status_dict[k] = {'text': v, 'count': 0}
        issues_status_data = models.Issues.objects.filter(project_id=pro_id).values('status').annotate(
            c=Count('id'))
        for i in issues_status_data:
            status_dict[i['status']]['count'] = i['c']
        # 项目成员数据
        user_list = models.ProjectUser.objects.filter(project_id=pro_id).values('user__id', 'user__username')

        # 动态数据
        top_ten = models.Issues.objects.filter(assign__isnull=False).order_by('-id')[0:10]

        context = {
            'status_dict': status_dict,
            'user_list': user_list,
            'top_ten': top_ten,
        }
        return render(request, "app01/dashboard.html", context)


# 获取概览页面中用来生成图表的数据
def issues_chart(request, pro_id):
    # 获取最近30天的吧
    # 推荐一个日期计算模块：python dateutils

    current_datetime = datetime.datetime.now()
    """
    data: [
        ['时间戳1', 问题数量],
        ['时间戳2', 问题数量],
        ...
    ]
    """
    '''
    id status ctime           create_datetime
    1  1      2018-01-01      2018-01-01 12:03:25


    '''
    date_dict = OrderedDict()
    for i in range(0, 30):
        date = current_datetime - datetime.timedelta(days=i)
        date_dict[date.strftime('%Y-%m-%d')] = [time.mktime(date.timetuple()) * 1000, 0]
    '''
    date_dict = {
        '2018-01-01':[1598242461000,0],
        '2018-01-02':[1598242461000,3]
    }
    '''

    # 2018-01-01 12:03:25
    # sqllte使用这个：strftime('%%Y-%%m-%%d', app01_issues.create_datetime)
    result = models.Issues.objects.filter(project_id=pro_id,
                                          create_datetime__gte=current_datetime - datetime.timedelta(days=30)).extra(
        select={'ctime': "date_format(app01_issues.create_datetime,'%%Y-%%m-%%d')"}).values('ctime').annotate(c=Count('id'))
    # queryst[{'ctime':'2018-01-01', 'c': 10},{'ctime':'2018-01-02', 'c': 8},{'ctime':'2018-01-04', 'c': 6}]
    for item in result:
        date_dict[item['ctime']][1] = item['c']
    return JsonResponse({'status': True, 'data': list(date_dict.values())})






