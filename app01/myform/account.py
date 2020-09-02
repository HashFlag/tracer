import re
import json
import random
from django import forms
from app01 import models
from django.db.models import Q
from utils.enc import set_md5
from utils.bootstrap import BootstrapForm
from django.forms import widgets
from django.core.exceptions import ValidationError
from django_redis import get_redis_connection
from django.conf import settings
from libs.aliyun import sms


def mobile_validate(value):
    """ 手机号验证规则 """
    mobile_re = re.compile(r"^(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57]|19[0-9])[0-9]{8}$")
    if not mobile_re.match(value):
        raise ValidationError('手机号码格式错误')


class RegisterModelForm(BootstrapForm, forms.ModelForm):
    """ 注册ModelForm校验 """
    phone = forms.CharField(
        label="手机号",
        validators=[mobile_validate,]
    )

    password = forms.CharField(
        label="密码",
        max_length=8,
        min_length=4,
        widget=widgets.PasswordInput,
        error_messages={
            'max_length': "最长不能超过8位",
            'min_length': "最短不能小于4位"
        }
    )

    confirm_password = forms.CharField(
        label='确认密码',
        max_length=8,
        min_length=4,
        widget=widgets.PasswordInput,
        error_messages={
            'max_length': "最长不能超过8位",
            'min_length': "最短不能小于4位"
        }
    )

    yzm = forms.CharField(
        label="验证码",
        widget=widgets.Input
    )

    class Meta:
        model = models.UserInfo
        # 调整字段顺序
        fields = ['username', 'email', 'phone', 'password']

    # def __init__(self, *args, **kwargs):
    #     super().__init__(*args, **kwargs)
    #     for name, field in self.fields.items():
    #         field.widget.attrs.update({'class': 'form-control input-sm', 'placeholder': '请输入%s' % (field.label,)})

    # 用户名唯一性校验
    def clean_name(self):
        username = self.cleaned_data.get('username', '')
        exists = models.UserInfo.objects.filter(username=username).exists()
        if exists:
            raise ValidationError('用户名已存在！')
        return username

    # 邮箱唯一性校验
    def clean_email(self):
        email = self.cleaned_data.get("email", "")
        exists = models.UserInfo.objects.filter(email=email).exists()
        if exists:
            raise ValidationError("邮箱已被注册！")
        return email

    # 手机号唯一性校验
    def clean_phone(self):
        phone = self.cleaned_data.get("phone", "")
        exists = models.UserInfo.objects.filter(phone=phone).exists()
        if exists:
            raise ValidationError("手机号已被注册！")
        return phone

    # 密码加密
    def clean_password(self):
        password = self.cleaned_data.get("password", "")
        return set_md5(password)

    # 密码校验
    def clean(self):
        pwd1 = self.cleaned_data.get("password", "")
        pwd2 = set_md5(self.cleaned_data.get("confirm_password", ""))
        if pwd1.strip() != pwd2.strip():
            self.add_error('confirm_password', "两次密码不一致")
        return self.cleaned_data

    # 验证码校验
    def clean_yzm(self):
        phone = self.cleaned_data.get('phone')
        conn = get_redis_connection('sms_send')
        sms_code = self.cleaned_data.get('yzm')
        redis_code = conn.get(phone)

        if not redis_code:
            raise ValidationError('验证码已失效')
        redis_code = redis_code.decode('utf-8')
        if sms_code.strip() != redis_code:
            raise ValidationError('验证码输入有误')
        return redis_code


class SmsForm(forms.Form):
    """ 验证码数据模板验证 """
    phone = forms.CharField(
        label="手机号",
        validators=[mobile_validate, ],
    )

    def __init__(self, request, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.request = request

    def clean_phone(self):
        phone = self.cleaned_data.get('phone')
        tpl = self.request.POST.get('tpl')

        # 获取短信验证的状态
        try:
            tpl_id = settings.SMS_TEMPLATE_ID[tpl]
        except:
            raise ValidationError("短信模板错误！")

        # 手机号查询校验
        obj_list = models.UserInfo.objects.filter(phone=phone)
        if tpl == "register":
            # 唯一性判断
            if obj_list.exists():
                raise ValidationError("手机号已被注册！")
        elif tpl == "login":
            # 验证是否注册
            if not obj_list.exists():
                raise ValidationError("手机号未注册！")

        # 检验验证码是否已经发送过，是否过期
        conn = get_redis_connection("sms_send")
        ret = conn.get(phone)
        if ret:
            raise ValidationError("验证码已发送！")

        # 生成随机验证码
        sms_code = '%06d' % random.randint(1, 999999)
        template_code = {
            'code': sms_code
        }
        # 写入redis数据库
        try:
            conn.set(phone, sms_code, ex=settings.SMS_CODE_EXPIRE)
        except:
            raise ValidationError("写入数据库错误")

        # 发送操作
        sms_obj = sms.send_sms(template_code, phone, tpl_id)
        sms_obj = json.loads(sms_obj)
        print(sms_obj)
        if sms_obj.get('Message') != 'OK' or sms_obj.get('Code') != 'OK':
            raise ValidationError('短信发送失败！')
        return phone


class LoginSmsForm(BootstrapForm, forms.Form):
    """ 登录Form验证 """
    phone = forms.CharField(
        label='手机号',
        validators=[mobile_validate, ],
        widget=widgets.Input
    )
    yzm = forms.CharField(
        label="验证码",
        widget=widgets.Input
    )

    # 手机号验证
    def clean_phone(self):
        phone = self.cleaned_data.get('phone')
        exists = models.UserInfo.objects.filter(phone=phone).exists()
        if not exists:
            raise ValidationError("手机号不存在！")
        return phone

    # 验证码校验
    def clean_yzm(self):
        phone = self.cleaned_data.get('phone')
        conn = get_redis_connection('sms_send')
        sms_code = self.cleaned_data.get('yzm')
        redis_code = conn.get(phone)

        if not redis_code:
            raise ValidationError('验证码已失效')
        redis_code = redis_code.decode('utf-8')
        if sms_code.strip() != redis_code:
            raise ValidationError('验证码输入有误')
        return redis_code


class LoginForm(BootstrapForm, forms.Form):
    """ 图片验证码登录 """
    username = forms.CharField(
        label="邮箱或手机号",
        widget=widgets.Input
    )
    password = forms.CharField(
        label="密码",
        widget=widgets.PasswordInput
    )
    image_code = forms.CharField(
        label="图片验证码",
        widget=widgets.Input
    )

    def __init__(self,request, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.request = request

    def clean_password(self):
        pwd = self.cleaned_data.get('password')
        return set_md5(pwd)

    # 图片验证码的验证
    # 用户输入的和后台保存的要一致
    def clean_image_code(self):
        user_code = self.cleaned_data.get('image_code')
        session_code = self.request.session.get('image_code')
        # 判断session_code是否已经失效
        if not session_code:
            raise ValidationError('验证码已失效！')

        if user_code.strip().upper() != session_code.upper():
            raise ValidationError('验证码错误！')

        return session_code

    def clean(self):

        pwd = self.cleaned_data.get('password')
        uname = self.cleaned_data.get('username')
        exists = models.UserInfo.objects.filter(
            Q(phone=uname) | Q(email=uname),
            password=pwd).exists()
        if not exists:
            self.add_error('username', '用户名或者密码有误！')

        return self.cleaned_data



