import json
import uuid
import datetime
from django import views
from django.urls import reverse
from app01.mymodels import account
from utils.img_code import image_code
from django.conf import settings
from django.shortcuts import render, HttpResponse, redirect
from app01 import models
from django.db.models import Q

msg_data = {'status': False, 'error_msg': '', 'path': ''}


class Register(views.View):
    """ 注册 """
    def get(self, request):
        UserInfo = account.RegisterModelForm()
        return render(request, "app01/register.html",
                      {'userinfo': UserInfo})

    # todo 校验注册数据
    def post(self, request):
        form = account.RegisterModelForm(request.POST)
        global msg_data
        if form.is_valid():
            instance = form.save()
            # 注册成功后，直接给用户一个免费的策略
            price_policy_obj = models.PricePolicy.objects.filter(catogory=1, title='免费版').first()
            # 创建交易记录
            models.Transaction.objects.create(
                status=2,
                order=uuid.uuid4(),
                user=instance,
                price_policy=price_policy_obj,
                count=0,
                price=0,
                start_datetime=datetime.datetime.now(),
            )
            msg_data['path'] = reverse('app01:login')
            msg_data['status'] = True
            return HttpResponse(json.dumps(msg_data))
        else:
            msg_data['error_msg'] = form.errors
            msg_data['status'] = False
            return HttpResponse(json.dumps(msg_data))


class LoginSms(views.View):
    """ 短信验证码登录 """
    def get(self, request):
        form = account.LoginSmsForm()
        return render(request, "app01/login_sms.html", {'form': form})

    def post(self, request):
        form = account.LoginSmsForm(request.POST)
        global msg_data
        if form.is_valid():
            # todo 将登录成功之后的数据保存到session，便后续使用
            phone = request.POST.get("phone")
            user_obj = models.UserInfo.objects.filter(phone=phone).first()
            request.session.flush()
            request.session['user_id'] = user_obj.id
            msg_data['path'] = reverse('app01:index')
            msg_data['status'] = True
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
        return HttpResponse(json.dumps(msg_data))

    def post(self, request):
        form = account.SmsForm(request, data=request.POST)
        global msg_data
        if form.is_valid():
            msg_data['status'] = True
            return HttpResponse(json.dumps(msg_data))
        else:
            msg_data['status'] = False
            msg_data['error_msg'] = form.errors
            return HttpResponse(json.dumps(msg_data))


class Login(views.View):
    """ 图片验证码登录 """
    def get(self, request):
        form = account.LoginForm(request)
        return render(request, "app01/login.html", {'form': form})

    def post(self, request):
        form = account.LoginForm(request, request.POST)
        global msg_data
        if form.is_valid():
            # todo 将登录成功之后的数据保存到session，便后续使用
            username = request.POST.get('username')
            user_obj = models.UserInfo.objects.filter(Q(phone=username) | Q(email=username)).first()
            request.session.flush()  # 清空session
            request.session["user_id"] = user_obj.id
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
    """ 图片验证码 """
    from io import BytesIO
    stream = BytesIO()
    img, code = image_code()
    img.save(stream, format='png')
    # 将图片验证码保存到session中
    request.session['image_code'] = code
    # 图片验证码有效期,单位秒
    request.session.set_expiry(settings.IMAGE_CODE_EXPIRE)
    return HttpResponse(stream.getvalue())


def logout(request):
    """ 注销用户 """
    request.session.flush()
    return redirect('/app01/login/')  # 可以使用路径反向解析：redirect('app01:login')












