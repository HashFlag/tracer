from aliyunsdkcore.client import AcsClient
from aliyunsdkcore.request import CommonRequest


def send_sms(template, phone, template_code):
    client = AcsClient(
        'LTAI4GAo2L2wEXX7HqgLJTNz',
        'Xi6k8iIEeEG0Ag8jjxLKHHBxSv0Eyz',
        'cn-hangzhou')
    # 短信里面的 我的AccessKey ID 我的Access Key Secret
    request = CommonRequest()
    request.set_accept_format('json')
    request.set_domain('dysmsapi.aliyuncs.com')
    request.set_method('POST')
    request.set_protocol_type('http')  # https | http 注意当项目发布到服务器上需要修改协议
    request.set_version('2017-05-25')

    # set_action_name 这个是选择你调用的接口的名称，如：SendSms，SendBatchSms等
    request.set_action_name('SendSms')
    # request.set_action_name('QuerySendDetails')

    # 这个参数也是固定的
    request.add_query_param('RegionId', "cn-hangzhou")  # 98A66994-3DF4-4FA5-A33F-CCB36EB599D0
    # request.add_query_param('RegionId', "cn-hangzhou")

    request.add_query_param('PhoneNumbers', phone)  # 发给谁
    request.add_query_param('SignName', "bzboy")  # 签名
    request.add_query_param('TemplateCode', template_code)  # 模板编号
    request.add_query_param('TemplateParam', f"{template}")  # 发送验证码内容
    response = client.do_action_with_exception(request)
    return response




