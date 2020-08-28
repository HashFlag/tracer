from django import forms
from app01 import models
from utils.bootstrap import BootstrapForm
from django.core.validators import ValidationError


class FileModelForm(BootstrapForm, forms.ModelForm):
    class Meta:
        model = models.FileRepository
        fields = ['name', ]

    def __init__(self, request, parent_obj, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.request = request
        self.parent_obj = parent_obj

    def clean_name(self):
        name = self.cleaned_data.get('name')
        queryset = models.FileRepository.objects.filter(
            file_type=2,
            name=name,
            project=self.request.tracer_obj.project,
        )
        if self.parent_obj:
            exists = queryset.filter(parent=self.parent_obj).exists()
        else:
            exists = queryset.filter(parent__isnull=True)
        if exists:
            raise ValidationError("文件夹已存在")

        return name


class FilteMsgModelForm(forms.ModelForm):
    # etag = forms.CharField(label='etag')  # 后端远程验证数据存不存在时用的

    class Meta:
        model = models.FileRepository
        exclude = ['project', 'file_type', 'update_user', 'update_datetime', ]

    def clean_file_path(self):
        file_path = self.cleaned_data.get('file_path').split('?uploadId=')[0]
        return file_path











