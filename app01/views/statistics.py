from django.shortcuts import render
from django import views
from app01 import models
from django.db.models import Count
from collections import OrderedDict
from django.http import JsonResponse


class Statistics(views.View):
    """ 统计 """
    def get(self, request, pro_id):
        return render(request, "app01/statistics.html")


def statistics_priority(request, pro_id):
    """ 优先级统计 """
    '''
        数据结构
        [{
                name: '高级',
                y: 10
        }, {
                name: '中级',
                y: 8
        }, {
                name: '低级',
                y: 20
        }, ]
        }]
        '''
    start = request.GET.get('start')
    end = request.GET.get('end')
    print(start,end)

    # 构造字典
    data_dict = OrderedDict()
    for key, text in models.Issues.priority_choices:
        data_dict[key] = {'name': text, 'y': 0}

    result = models.Issues.objects.filter(project_id=pro_id, create_datetime__gte=start,
                                          create_datetime__lt=end).values('priority').annotate(c=Count('id'))
    print(">>>result:", result)
    # [{'priority':1,'c':2},{'priority':2,'c':3}]
    for item in result:
        data_dict[item['priority']]['y'] = item['c']
    print(">>>:", data_dict)
    return JsonResponse({'status': True, 'data': list(data_dict.values())})


def statistics_people(request, pro_id):
    """ 人员统计 """

    # 获取人员任务进度数据
    start = request.GET.get('start')
    end = request.GET.get('end')

    '''
    info = {
        1:{   //用户id
            name:'chao',
            status:{
                1:0,
                2:0,
                3:0,
                4:0,
                5:0,
                6:0,
                7:0,
            }
        },
        2:{   //用户id
            name:'simin',
            status:{
                1:1,
                2:0,
                3:0,
                4:0,
                5:0,
                6:0,
                7:0,
            }
        },
        None:{   //用户id
            name:'未指派',
            status:{
                1:0,
                2:0,
                3:0,
                4:0,
                5:0,
                6:0,
                7:0,
            }
        },
    }

    # categories: ['吴超', '王振', '刘伟']

    {
        name: '新建',
        data: [5, 3, 4] //和横轴坐标是一一对应的
    }, {
        name: '处理中',
        data: [2, 2, 3]
    }, {
        name: '已解决',
        data: [3, 4, 4]
    }

    '''

    # 所有成员 以及 未指派数据
    all_user_dict = OrderedDict()
    # 创建者数据
    all_user_dict[request.tracer_obj.project.creator.id] = {
        'name': request.tracer_obj.project.creator.username,
        'status': {item[0]: 0 for item in models.Issues.status_choices}
    }

    # 未指派的数据
    all_user_dict[None] = {
        'name': '未指派',
        'status': {item[0]: 0 for item in models.Issues.status_choices}
    }
    # 参与者的数据
    user_list = models.ProjectUser.objects.filter(project_id=pro_id)
    for item in user_list:
        all_user_dict[item.user_id] = {
            'name': item.user.username,
            'status': {item[0]: 0 for item in models.Issues.status_choices}
        }

    # 将所有问题数据分类
    issues_objs = models.Issues.objects.filter(project_id=pro_id, create_datetime__gte=start,
                                               create_datetime__lt=end)
    for i in issues_objs:
        if not i.assign:  # 未指派的
            all_user_dict[None]['status'][i.status] += 1

        else:
            all_user_dict[i.assign_id]['status'][i.status] += 1

    # 获取所有成员名称
    categories = [data['name'] for data in all_user_dict.values()]
    '''
    d1 = {
        1:{name:'新建', data:[1,1,2]},
        2:{name:'已解决', data:[5,1,2]},
        3:{name:'已处理', data:[2,1,2]},
        4:{name:'待反馈', data:[1,3,2]},
        5:{name:'处理中', data:[4,1,2]},
    }
    d1.values()

    '''
    result_dict = OrderedDict()
    for item in models.Issues.status_choices:
        result_dict[item[0]] = {
            'name': item[1], 'data': []
        }

    for k, v in models.Issues.status_choices:
        # k=1 ,v='新建'
        for row in all_user_dict.values():
            count = row['status'][k]  #
            result_dict[k]['data'].append(count)

    context = {
        'status': True,
        'categories': categories,
        'data': list(result_dict.values()),
    }

    return JsonResponse(context)
