import datetime
from django import template
from app01 import models
register = template.Library()


@register.simple_tag
def project_creator(request):
    transaction_obj = models.Transaction.objects.filter(user=request.tracer_obj.project.creator, status=2, ).order_by(
        '-id').first()
    end_datetime = transaction_obj.end_datetime

    current_time = datetime.datetime.now()
    # 如果过期了
    if end_datetime and end_datetime < current_time:
        # 根据购买记录找到对应的策略,然后将策略保存到request对象中
        price_policy = models.PricePolicy.objects.filter(catogory=1, title='免费').first()
        price_policy = price_policy

    else:
        price_policy = transaction_obj.price_policy

    return price_policy.project_space









