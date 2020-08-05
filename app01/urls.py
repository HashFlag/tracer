from django.conf.urls import url
from app01.views import account
urlpatterns = [
    url(r'^register/', account.Register.as_view(), name="register"),
    url(r'^send/sms_code/', account.SmsSendCode.as_view(), name="sms_code"),
    url(r'^login_sms/', account.LoginSms.as_view(), name="login_sms"),
    url(r'login/', account.Login.as_view(), name="login"),
    url(r'^index/', account.Index.as_view(), name="index"),
    url(r'^img_code/', account.img_code, name="img_code"),
]










