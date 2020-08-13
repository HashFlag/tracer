import oss2
from django.conf import settings

# 阿里云主账号AccessKey拥有所有API的访问权限，风险很高。强烈建议您创建并使用RAM账号进行API访问或日常运维，请登录 https://ram.console.aliyun.com 创建RAM账号。
auth = oss2.Auth('LTAI4GAo2L2wEXX7HqgLJTNz', 'Xi6k8iIEeEG0Ag8jjxLKHHBxSv0Eyz')
# Endpoint以杭州为例，其它Region请按实际情况填写。
bucket = oss2.Bucket(auth, 'http://oss-cn-beijing.aliyuncs.com', 'bzboy-tracer')

bucket.put_object_from_file('wlop', 'wlop.jpg')








