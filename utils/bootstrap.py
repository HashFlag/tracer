class BootstrapForm:
    bootstrap_class_exclude = []

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        for name, field in self.fields.items():
            if name in self.bootstrap_class_exclude:
                continue

            # 防止Meta中的class原属性被覆盖
            old_class = field.widget.attrs.get('class', '')
            field.widget.attrs['class'] = '{} form-control input-sm'.format(old_class)
            field.widget.attrs.update({'placeholder': '请输入' + field.label})
            # field.widget.attrs.update({'class': 'form-control input-sm', 'placeholder': '请输入%s' % (field.label,)})












