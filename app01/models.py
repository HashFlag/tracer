from django.db import models
# Create your models here.


class UserInfo(models.Model):
    username = models.CharField(max_length=32, verbose_name="用户名")
    phone = models.CharField(max_length=11, verbose_name="手机号", unique=True)
    email = models.EmailField(max_length=32, verbose_name="邮箱")
    password = models.CharField(max_length=32, verbose_name="密码")










