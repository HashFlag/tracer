class BootstrapForm:
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        for name, field in self.fields.items():
            field.widget.attrs.update({'class': 'form-control input-sm', 'placeholder': '请输入%s' % (field.label,)})











