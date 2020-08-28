import datetime
from django.utils.deprecation import MiddlewareMixin
from django.conf import settings
from app01 import models
from django.shortcuts import redirect


class tracer:
    def __init__(self):
        self.user_obj = None
        self.price_policy = None
        self.project = None


class LoginAuth(MiddlewareMixin):
    def process_request(self, request):
        current_path = request.path
        user_id = request.session.get("user_id")
        tracer_obj = tracer()
        request.tracer_obj = tracer_obj
        user_obj = models.UserInfo.objects.filter(pk=user_id).first()
        request.tracer_obj.user_obj = user_obj

        # 白名单判断，在白名单中就放行
        if current_path in settings.WHITE_LIST:
            return
        # 重定向页面
        if not user_id:
            return redirect('app01:login')

        # 将当前用户的购买策略加到request对象中，方便后面使用
        tra_obj = models.Transaction.objects.filter(
            user=request.tracer_obj.user_obj
        ).order_by('-id').first()

        # 判断是否过期
        # 先看一下是不是免费版的，通过结束时间来判断
        end_datetime = tra_obj.end_datetime
        current_time = datetime.datetime.now()
        # 如果过期
        if end_datetime and end_datetime < current_time:
            # 根据购买记录找到对应的策略,然后将策略保存到request对象中
            price_policy = models.PricePolicy.objects.filter(catogory=1, title='免费').first()
            request.tracer_obj.price_policy = price_policy
        else:
            # 没过期，就把当前策略添加到这里
            request.tracer_obj.price_policy = tra_obj.price_policy

    def process_view(self, request, view, args, kwargs):
        if not request.path.startswith('/app01/manage/'):
            return
        pro_id = kwargs.get('pro_id')

        # 我创建的
        project_obj = models.Project.objects.filter(
            id=pro_id, creator=request.tracer_obj.user_obj)
        if project_obj:
            request.tracer_obj.project = project_obj.first()
            return

        # 我参与的
        project_obj = models.ProjectUser.objects.filter(
            project_id=pro_id, user=request.tracer_obj.user_obj
        )
        if project_obj:
            request.tracer_obj.project = project_obj.first().project
            return

        return redirect('app01:project_list')




