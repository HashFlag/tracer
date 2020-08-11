from app01 import models
from django import forms
from utils.bootstrap import BootstrapForm


class WiKiModelForm(BootstrapForm, forms.ModelForm):
    """ WiKi """
    class Meta:
        model = models.Wiki
        exclude = ['project', 'deepth', ]

    def __init__(self, request, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.request = request
        self.fields['parent'].queryset = models.Wiki.objects.filter(
            project=self.request.tracer_obj.project)






