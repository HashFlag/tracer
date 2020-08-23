from django import template
register = template.Library()


@register.simple_tag
def issues_format_tag(id):
    if id < 100:
        # id = '%03d' % id
        id = str(id).rjust(3, '0')
    return '#{}'.format(id)









