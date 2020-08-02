from django.db import models
# Create your models here.


class UserInfo(models.Model):
    username = models.CharField(max_length=32)
    password = models.CharField(max_length=32)
    phone = models.CharField(max_length=11)
    email = models.EmailField(max_length=32)










