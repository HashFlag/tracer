from django import forms
from app01 import models
from utils.bootstrap import BootstrapForm


class IssuesModelForm(BootstrapForm, forms.ModelForm):
    """ 问题ModelForm """
    class Meta:
        model = models.Issues
        exclude = [
            'project', 'creator',
            'create_datetime',
            'latest_update_datetime'
        ]
        widgets = {
            'assign': forms.Select(attrs={'class': 'selectpicker', 'data-live-search': 'true'}),
            'attention': forms.SelectMultiple(
                attrs={'class': 'selectpicker', 'data-live-search': 'true', 'data-actions-box': "true"}
            ),
            'parent': forms.Select(attrs={'class': 'selectpicker', 'data-live-search': 'true'})
        }

    def __init__(self, request, *args, **kwargs):
        super().__init__(*args, **kwargs)
        # 数据初始化
        # 筛选当前项目的问题类型
        self.fields['issues_type'].choices = models.IssuesType.objects.filter(project=request.tracer_obj.project).values_list('id', 'title')
        # 筛选当前项目的模块
        self.fields['module'].queryset = models.Module.objects.filter(project=request.tracer_obj.project)

        # 筛选指派者，筛选当前项目的参与者和创建者
        # 找创建者
        total_user_list = [
            (request.tracer_obj.project.creator_id, request.tracer_obj.project.creator, )
        ]
        # 找参与者
        project_user_list = models.ProjectUser.objects.filter(
            project=request.tracer_obj.project,
        ).values_list('user__id', 'user__username')

        total_user_list.extend(project_user_list)

        self.fields['assign'].choices = [('', '---------')] + total_user_list
        self.fields['attention'].choices = total_user_list

        # 父问题筛选(choice和queryset都可以)
        self.fields['parent'].queryset = models.Issues.objects.filter(
            project=request.tracer_obj.project,
        )


class IssuesReplyModelForm(forms.ModelForm):

    class Meta:
        model = models.IssuesReply
        fields = ['content', 'reply']


class InviteModelForm(BootstrapForm, forms.ModelForm):
    class Meta:
        model = models.ProjectInvite
        fields = ['period', 'count']
