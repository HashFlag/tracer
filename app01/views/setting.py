from django.shortcuts import render, redirect
from django import views
from libs.aliyun.oss import delete_bucket, delete_bucket_file
from app01 import models
from threading import Timer
from utils.enc import set_md5


class Setting(views.View):
    """ 设置 """
    def get(self, request, pro_id):
        return render(request, "app01/settings.html")

    def post(self, request, pro_id):
        return


class SettingDelete(views.View):
    """ 删除项目 """
    def get(self, request, pro_id):
        return render(request, 'app01/setting_delete.html')

    def post(self, request, pro_id):
        project_name = request.POST.get('project_name')
        if not project_name or project_name != request.tracer_obj.project.name:
            return render(request, 'app01/setting_delete.html', {'error': '项目名有误！'})

        # 只有创建者才能进行删除
        if request.tracer_obj.user_obj != request.tracer_obj.project.creator:
            return render(request, 'app01/setting_delete.html', {'error': '只有项目创建者可以进行删除！'})

        # 删除桶
        # 先删除文件和文件碎片
        delete_bucket_file(request.tracer_obj.project.bucket)

        # 指定26小时后执行delete函数
        try:
            t = Timer(1.0 * 60 * 60 * 26, delete_bucket, (request.tracer_obj.project.bucket, ))
            t.start()
        except:
            render(request, 'app01/setting_delete.html', {'error': "特殊原因删除失败，请联系管理员"})

        # 删除数据库中的项目数据
        models.Project.objects.filter(id=request.tracer_obj.project.id).delete()
        delete_bucket(request.tracer_obj.project.bucket)
        return redirect('app01:project_list')


class SettingPassword(views.View):
    """ 修改密码 """
    def get(self, request, pro_id):
        return render(request, 'app01/setting_password.html')

    def post(self, request, pro_id):
        old_pwd = request.POST.get('old-password')
        new_pwd = request.POST.get('new-password')
        true_pwd = request.POST.get('true-password')
        if not old_pwd and new_pwd and true_pwd:
            return render(request, 'app01/setting_password.html', {"error": "密码不能为空！"})
        if set_md5(old_pwd) != request.tracer_obj.user_obj.password:
            return render(request, 'app01/setting_password.html', {"error": "旧密码错误,请重新输入！"})
        else:
            if old_pwd == new_pwd:
                return render(request, 'app01/setting_password.html', {"error": "新密码与旧新密码不能相同,请重新输入！"})
            if new_pwd != true_pwd:
                return render(request, 'app01/setting_password.html', {"error": "新密码与确认新密码不一致,请重新输入！"})
            else:
                request.tracer_obj.user_obj.password = set_md5(new_pwd)
                request.tracer_obj.user_obj.save()
                return redirect('app01:login')






