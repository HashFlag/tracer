# Author：wylkjj
# Date：2020/8/1
# -*- coding:utf-8 -*-
from aliyunsdkcore.client import AcsClient
from aliyunsdkcore.request import CommonRequest
client = AcsClient('<accessKeyId>', '<accessSecret>', 'cn-hangzhou')

request = CommonRequest()
request.set_accept_format('json')
request.set_domain('dysmsapi.aliyuncs.com')
request.set_method('POST')
request.set_protocol_type('https')  # https | http
request.set_version('2017-05-25')
request.set_action_name('AddSmsSign')

request.add_query_param('RegionId', "cn-hangzhou")

response = client.do_action(request)
# python2:  print(response)
print(str(response, encoding='utf-8'))







