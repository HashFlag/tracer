from django.conf.urls import url
from app01.views import account, project
urlpatterns = [
    url(r'^register/', account.Register.as_view(), name="register"),
    url(r'^send/sms_code/', account.SmsSendCode.as_view(), name="sms_code"),
    url(r'^login_sms/', account.LoginSms.as_view(), name="login_sms"),
    url(r'login/', account.Login.as_view(), name="login"),
    url(r'^index/', account.Index.as_view(), name="index"),
    url(r'^img_code/', account.img_code, name="img_code"),
    url(r'^logout/', account.logout, name="logout"),
    url(r'^project_list/', project.ProjectList.as_view(), name="project_list"),
    url(r'^project/star/(\w+)/(\d+)/', project.project_star, name="project_star"),
    url(r'^project/unstar/(\w+)/(\d+)/', project.project_unstar, name="project_unstar"),
]










