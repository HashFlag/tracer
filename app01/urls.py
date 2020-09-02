from django.conf.urls import url, include
from app01.views import account, project, dashboard, \
    issues, file, setting, wiki, statistics, pay
from django.views.decorators.csrf import csrf_exempt

urlpatterns = [
    url(r'^index/', account.Index.as_view(), name="index"),
    url(r'^register/', account.Register.as_view(), name="register"),
    url(r'^send/sms_code/', account.SmsSendCode.as_view(), name="sms_code"),
    url(r'^login_sms/', account.LoginSms.as_view(), name="login_sms"),
    url(r'login/', account.Login.as_view(), name="login"),
    url(r'^price/', pay.Price.as_view(), name="price"),
    url(r'^pay/', pay.pay, name='pay'),
    url(r'^pay_notify/', pay.pay_notify, name='pay_notify'),
    url(r'^payment/(?P<policy_id>\d+)/', pay.Payment.as_view(), name="payment"),
    url(r'^img_code/', account.img_code, name="img_code"),
    url(r'^logout/', account.logout, name="logout"),
    url(r'^project_list/', project.ProjectList.as_view(), name="project_list"),
    url(r'^project/star/(\w+)/(\d+)/', project.project_star, name="project_star"),
    url(r'^project/unstar/(\w+)/(\d+)/', project.project_unstar, name="project_unstar"),
    url(r'invite_join/(?P<code>\w+)/', issues.invite_join, name='invite_join'),
    url(r'^manage/(?P<pro_id>\d+)/', include([
        # 概览
        url(r'dashboard/', dashboard.Dashboard.as_view(), name='dashboard'),
        url(r'issues_chart/', dashboard.issues_chart, name='issues_chart'),
        # 问题管理
        url(r'issues/', issues.Issues.as_view(), name='issues'),
        url(r'issues_detail/(?P<issues_id>\d+)/', issues.IssuesDetail.as_view(), name='issues_detail'),
        url(r'issues_record/(?P<issues_id>\d+)/', csrf_exempt(issues.IssuesRecord.as_view()), name='issues_record'),
        url(r'issues_change/(?P<issues_id>\d+)/', issues.issues_change, name='issues_change'),
        url(r'invite_url/', issues.invite_url, name='invite_url'),
        # 文件页面
        url(r'file/', file.File.as_view(), name='file'),
        url(r'file_post/', file.file_post, name='file_post'),
        url(r'file_delete/', file.FileDelete.as_view(), name='file_delete'),
        url(r'file_download/', file.file_download, name='file_download'),
        url(r'cos/credential/$', file.cos_credential, name='cos_credential'),

        # 配置页面
        url(r'setting/', setting.Setting.as_view(), name='setting'),
        url(r'setting_delete/', setting.SettingDelete.as_view(), name='setting_delete'),
        url(r'setting_password/', setting.SettingPassword.as_view(), name='setting_password'),

        # wiki页面
        url(r'wiki/', wiki.WiKi.as_view(), name='wiki'),
        url(r'wiki_add/', wiki.WikiAdd.as_view(), name='wiki_add'),
        url(r'wiki_data/', wiki.wiki_data, name='wiki_data'),
        url(r'wiki_upload/', wiki.wiki_upload, name='wiki_upload'),
        url(r'wiki_delete/(?P<wiki_id>\d+)/', wiki.wiki_delete, name='wiki_delete'),
        url(r'wiki_edit/(?P<wiki_id>\d+)/', wiki.WikiEdit.as_view(), name='wiki_edit'),
        # 统计
        url(r'statistics/', statistics.Statistics.as_view(), name='statistics'),
        url(r'statistics_priority/', statistics.statistics_priority, name='statistics_priority'),
        url(r'statistics_people/', statistics.statistics_people, name='statistics_people'),
    ])),
]










