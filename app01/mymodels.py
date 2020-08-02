from django import forms
from app01 import models


class UserInfoFrom(forms.ModelForm):
    class Meta:
        model = models.UserInfo
        fields = '__all__'
        labels = {
            'username': "用户名",
            'password': "密码",
            'phone': "电话",
            'email': "邮箱",
        }

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.fields.get("username").widget.attrs.update(
            {'class': 'form-control', 'placeholder': '请输入用户名'}
        )
        self.fields.get("password").widget.attrs.update(
            {'type': 'password', 'class': 'form-control', 'placeholder': '请输入密码'}
        )
        self.fields.get("phone").widget.attrs.update(
            {'class': 'form-control', 'placeholder': '请输入电话'}
        )
        self.fields.get("email").widget.attrs.update(
            {'type': 'email', 'class': 'form-control', 'placeholder': '请输入邮箱'}
        )










