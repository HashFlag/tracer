from django.conf.urls import url
from app01.views import account
urlpatterns = [
    url(r'^register/', account.Register.as_view(), name="register"),
    url(r'^send/sms_code/', account.SmsSendCode.as_view(), name="sms_code"),
    url(r'^login/', account.Login.as_view(), name="login"),
]










