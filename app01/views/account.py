import json
from django.shortcuts import render, HttpResponse
from django import views
from django.urls import reverse
from app01.mymodels import mymodels


class Register(views.View):
    """ 注册 """
    def get(self, request):
        UserInfo = mymodels.RegisterModelForm()
        # print("UserInfo:", UserInfo)
        return render(request, "app01/register.html",
                      {'userinfo': UserInfo})

    def post(self, request):
        form = mymodels.RegisterModelForm(request.POST)
        if form.is_valid():
            # print(form.is_valid())
            instance = form.save()
            error_data = {'status': True, 'path': reverse('app01:login')}
            return HttpResponse(json.dumps(error_data))
        else:
            error_data = {'status': False, 'error_msg': form.errors}
            return HttpResponse(json.dumps(error_data))


class Login(views.View):
    """ 登录 """
    def get(self, request):
        form = mymodels.LoginForm()
        return render(request, "app01/login.html", {'form': form})

    def post(self, request):
        pass


class SmsSendCode(views.View):
    """ 验证码 """
    def get(self, request):
        data = {'status': False, 'error_msg': "发送失败"}
        return HttpResponse(json.dumps(data))

    def post(self, request):
        form = mymodels.SmsForm(request, data=request.POST)
        if form.is_valid():
            data = {'status': True}
            return HttpResponse(json.dumps(data))
        else:
            data = {'status': False, 'error_msg': form.errors}
            return HttpResponse(json.dumps(data))






