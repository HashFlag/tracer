import json
from django import views
from django.urls import reverse
from app01.mymodels import mymodels
from utils.img_code import image_code
from django.conf import settings
from django.shortcuts import render, HttpResponse

msg_data = {'status': False, 'error_msg': '', 'path': ''}


class Register(views.View):
    """ 注册 """
    def get(self, request):
        UserInfo = mymodels.RegisterModelForm()
        return render(request, "app01/register.html",
                      {'userinfo': UserInfo})

    # todo 校验注册数据
    def post(self, request):
        form = mymodels.RegisterModelForm(request.POST)
        global msg_data
        if form.is_valid():
            instance = form.save()
            msg_data['path'] = reverse('app01:login_sms')
            msg_data['status'] = True
            # msg_data = {'status': True, 'path': reverse('app01:login')}
            return HttpResponse(json.dumps(msg_data))
        else:
            msg_data['error_msg'] = form.errors
            msg_data['status'] = False
            # msg_data = {'status': False, 'error_msg': form.errors}
            return HttpResponse(json.dumps(msg_data))


class LoginSms(views.View):
    """ 短信验证码登录 """
    def get(self, request):
        form = mymodels.LoginSmsForm()
        return render(request, "app01/login_sms.html", {'form': form})

    def post(self, request):
        form = mymodels.LoginSmsForm(request.POST)
        global msg_data
        if form.is_valid():
            # todo 将登录成功之后的数据保存到session，便后续使用
            msg_data['path'] = reverse('app01:index')
            msg_data['status'] = True
            # data = {'status': True, 'path': reverse('index')}
            return HttpResponse(json.dumps(msg_data))
        else:
            msg_data['error_msg'] = form.errors
            msg_data['status'] = False
            return HttpResponse(json.dumps(msg_data))


class SmsSendCode(views.View):
    """ 验证码 """
    def get(self, request):
        global msg_data
        msg_data['error_msg'] = "发送失败"
        msg_data['status'] = False
        # data = {'status': False, 'error_msg': "发送失败"}
        return HttpResponse(json.dumps(msg_data))

    def post(self, request):
        form = mymodels.SmsForm(request, data=request.POST)
        global msg_data
        if form.is_valid():
            msg_data['status'] = True
            # data = {'status': True}
            return HttpResponse(json.dumps(msg_data))
        else:
            msg_data['status'] = False
            msg_data['error_msg'] = form.errors
            # data = {'status': False, 'error_msg': form.errors}
            return HttpResponse(json.dumps(msg_data))


class Login(views.View):
    """ 图片验证码登录 """
    def get(self, request):
        form = mymodels.LoginForm(request)
        return render(request, "app01/login.html", {'form': form})

    def post(self, request):
        form = mymodels.LoginForm(request, request.POST)
        global msg_data
        if form.is_valid():
            # todo 将登录成功之后的数据保存到session，便后续使用
            msg_data['path'] = reverse('app01:index')
            msg_data['status'] = True
            return HttpResponse(json.dumps(msg_data))
        else:
            msg_data['error_msg'] = form.errors
            msg_data['status'] = False
            return HttpResponse(json.dumps(msg_data))


class Index(views.View):
    """ 首页 """
    def get(self, request):
        return render(request, "app01/index.html")


def img_code(request):
    from io import BytesIO
    stream = BytesIO()
    img, code = image_code()
    img.save(stream, format='png')
    # 将图片验证码保存到session中
    request.session['image_code'] = code
    # 图片验证码有效期,单位秒
    request.session.set_expiry(settings.IMAGE_CODE_EXPIRE)
    return HttpResponse(stream.getvalue())
