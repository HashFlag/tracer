import re
import json
import random
from django import forms
from app01 import models
from utils.enc import set_md5
from utils.bootstrap import BootstrapForm
from django.forms import widgets
from django.core.exceptions import ValidationError
from django_redis import get_redis_connection
from django.conf import settings
from libs.aliyun import sms


def mobile_validate(value):
    """ 手机号验证规则 """
    mobile_re = re.compile(r"^(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$")
    if not mobile_re.match(value):
        raise ValidationError('手机号码格式错误')


class RegisterModelForm(BootstrapForm, forms.ModelForm):
    """ 生成前端input标签 """
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

    def clean_name(self):
        """ 用户名唯一性校验 """
        username = self.cleaned_data.get('username', '')
        exists = models.UserInfo.objects.filter(username=username).exists()
        if exists:
            raise ValidationError('用户名已存在！')
        return username

    def clean_email(self):
        """ 邮箱唯一性校验 """
        email = self.cleaned_data.get("email", "")
        exists = models.UserInfo.objects.filter(email=email).exists()
        if exists:
            raise ValidationError("邮箱已被注册！")
        return email

    def clean_phone(self):
        """ 手机号唯一性校验 """
        phone = self.cleaned_data.get("phone", "")
        exists = models.UserInfo.objects.filter(phone=phone).exists()
        if exists:
            raise ValidationError("手机号已被注册！")
        return phone

    def clean_password(self):
        """ 密码加密 """
        password = self.cleaned_data.get("password", "")
        return set_md5(password)

    def clean(self):
        """ 密码校验 """
        pwd1 = self.cleaned_data.get("password", "")
        pwd2 = set_md5(self.cleaned_data.get("confirm_password", ""))
        if pwd1.strip() != pwd2.strip():
            self.add_error('confirm_password', "两次密码不一致")
        return self.cleaned_data


class SmsForm(forms.Form):
    """ 验证码数据模板验证 """
    phone = forms.CharField(
        label="手机号",
        validators=[mobile_validate,],
    )

    def __init__(self, request, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.request = request

    def clean_phone(self):
        phone = self.cleaned_data.get('phone')
        # 手机号唯一性校验
        obj_list = models.UserInfo.objects.filter(phone=phone)
        if obj_list.exists():
            raise ValidationError("该手机号已被注册！")

        # 短信模板验证
        # tpl = self.request.POST.get("tpl")

        # 检验验证码是否已经发送过，是否过期
        conn = get_redis_connection("sms_send")
        ret = conn.get(phone)
        if ret:
            raise ValidationError("验证码已发送")

        # 生成随机验证码
        sms_code = '%06d' % random.randint(1, 999999)
        template_code = {
            'code': sms_code
        }
        # 写入redis数据库
        conn.set(phone, sms_code, ex=settings.SMS_CODE_EXPIRE)

        # 发送操作
        sms_obj = sms.send_sms(template_code, phone)
        sms_obj = json.loads(sms_obj)
        print(sms_obj)
        if sms_obj.get('Message') != 'OK' or sms_obj.get('Code') != 'OK':
            raise ValidationError('短信发送失败！')
        return phone


class LoginForm(BootstrapForm, forms.Form):
    phone = forms.CharField(
        label='手机号',
        validators=[mobile_validate, ],
        widget=widgets.Input
    )
    yzm = forms.CharField(
        label="验证码",
        widget=widgets.Input
    )

    # def clean_yzm(self):
    #     pass


