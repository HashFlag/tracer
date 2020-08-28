import json
import datetime
from django.shortcuts import render, HttpResponse, redirect
from django import views
from django_redis import get_redis_connection

from app01 import models
from django.conf import settings

from libs.alipay import AliPay
from utils.enc import uid


class Price(views.View):
    """ 会员价格 """
    def get(self, request):
        policy_list = models.PricePolicy.objects.all()
        return render(request, 'app01/price.html', {'policy_list': policy_list})


class Payment(views.View):
    """ 订单页面 """
    def get(self, request, policy_id):
        # 找到用户选择的价格策略
        policy_obj = models.PricePolicy.objects.filter(id=policy_id).first()
        if not policy_obj:
            return redirect('price')
        # 购买数量
        number = request.GET.get('number')
        if not number or not number.isdecimal():
            return redirect('price')

        number = int(number)
        if number < 1:
            return redirect('price')
        # 计算原价
        origin_price = number * policy_obj.price
        balance_price = 0
        obj = None
        # 抵扣，之前购买过，并且还没有过期，那我们将原套餐的剩余前数做一下抵扣
        if request.tracer_obj.price_policy.catogory != 1:
            obj = models.Transaction.objects.filter(status=2, user=request.tracer_obj.user_obj).order_by(
                '-id').first()
            # todo 需要判断是否已经过期了
            # 总天数
            total_days = obj.end_datetime - obj.start_datetime

            # 剩余天数
            balance_days = obj.end_datetime - datetime.datetime.now()

            # 计算抵扣价格
            # 如果刚买了套餐，又直接购买其他套餐，今天就应该给他扣除
            if total_days.days == balance_days.days:
                balance_price = obj.price * (balance_days.days - 1) / total_days.days
            else:
                balance_price = obj.price * (balance_days.days - 1) / total_days.days

            if balance_price >= origin_price:
                return redirect('price')

        context = {
            'policy_id': policy_obj.id,
            'number': number,
            'origin_price': origin_price,
            'balance': round(balance_price, 2),
            'total_price': origin_price - round(balance_price, 2)

        }

        conn = get_redis_connection()
        key = 'payment_{}'.format(request.tracer_obj.user_obj.phone)

        conn.set(key, json.dumps(context), ex=60 * 30)

        context['policy_obj'] = policy_obj
        context['transaction'] = obj

        return render(request, 'app01/order.html', context)


def pay(request):
    # 获取redis中的订单数据
    conn = get_redis_connection()
    key = 'payment_{}'.format(request.tracer_obj.user_obj.phone)
    context_string = conn.get(key)
    if not context_string:
        return redirect('price')

    context = json.loads(context_string.decode('utf-8'))

    # 数据库中生成交易记录(未支付)
    # 支付成功之后，将未支付状态改为已支付
    order_id = uid(request.tracer_obj.user_obj.phone)

    models.Transaction.objects.create(
        status=1,
        order=order_id,
        user=request.tracer_obj.user_obj,
        price_policy_id=context['policy_id'],
        count=context['number'],
        price=context['total_price'],

    )
    ali_pay = AliPay(
        appid=settings.ALI_APP_ID,
        app_notify_url=settings.ALI_NOTIFY_URL,
        return_url=settings.ALI_RETURN_URL,
        app_private_key_path=settings.APP_PRIVATE_KEY_PATH,
        alipay_public_key_path=settings.ALIPAY_PUBLIC_KEY_PATH,
    )
    params = ali_pay.direct_pay(
        subject='皇家赌场订单',
        out_trade_no=order_id,
        total_amount=context['total_price']
    )

    pay_url = '{}?{}'.format(settings.ALI_URL, params)

    return redirect(pay_url)


# 支付宝支付成功之后的通知url
def pay_notify(request):
    # print(request.method)
    ali_pay = AliPay(
        appid=settings.ALI_APP_ID,
        app_notify_url=settings.ALI_NOTIFY_URL,
        return_url=settings.ALI_RETURN_URL,
        app_private_key_path=settings.APP_PRIVATE_KEY_PATH,
        alipay_public_key_path=settings.ALIPAY_PUBLIC_KEY_PATH,
    )
    if request.method == 'GET':
        params = request.GET.dict()

        # sign = params.pop('sign')
        # status = ali_pay.verify(params, sign)
        # if status:
            # 修改订单状态
        order_id = params.get('out_trade_no')
        order_obj = models.Transaction.objects.filter(order=order_id).first()
        order_obj.status = 2
        order_obj.save()

        return HttpResponse('支付成功')

        # return HttpResponse('ok')

    else:
        from urllib.parse import parse_qs
        body_data = request.body.decode('utf-8')
        post_data = parse_qs(body_data) #{'key':[v1]}
        post_dict = {}
        for k, v in post_data.items():
            post_dict[k] = v[0]

        # sign = post_dict.pop('sign')
        # status = ali_pay.verify(post_dict, sign)
        # if status:
            # 修改订单状态

        return HttpResponse('success')

        # else:
        #     return HttpResponse('error')

# celery -- python3.7 -- django2.2
# docker nginx uwsgi...


