import time
from utils.bootstrap import BootstrapForm
from django import forms
from app01 import models
from django.core.validators import ValidationError
from app01.myform.widgets import ColorRadioSelect


class ProjectModelForm(BootstrapForm, forms.ModelForm):
    bootstrap_class_exclude = ['color', ]

    class Meta:
        model = models.Project
        fields = ['name', 'color', 'desc', ]
        widgets = {
            'desc': forms.Textarea,
            'color': ColorRadioSelect,
            # 'color': forms.RadioSelect,
        }

    def __init__(self, request, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.request = request

    def clean_name(self):
        name = self.cleaned_data.get('name')
        # 项目名唯一性校验
        exists = models.Project.objects.filter(name=name, creator=self.request.tracer_obj.user_obj).exists()
        if exists:
            raise ValidationError("项目名已存在！")
        count = models.Project.objects.filter(creator=self.request.tracer_obj.user_obj).count()
        if count >= self.request.tracer_obj.price_policy.project_num:
            raise ValidationError("项目数量已达上限，请升级账号")
        return name








