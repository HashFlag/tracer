import oss2
from django.conf import settings


def upload_file(img_name, img_obj, Bucket="bzboy-tracer"):
    # 阿里云主账号AccessKey拥有所有API的访问权限，风险很高。强烈建议您创建并使用RAM账号进行API访问或日常运维，请登录 https://ram.console.aliyun.com 创建RAM账号。
    auth = oss2.Auth(settings.ACCESSKEY_ID, settings.ACCESSKEY_SERECT)
    # Endpoint以北京为例，其它Region请按实际情况填写。
    bucket = oss2.Bucket(auth, 'http://oss-'+settings.REGION_ID+'.aliyuncs.com', Bucket)
    bucket.put_object(img_name, img_obj)

    return "https://{0}.oss-{1}.aliyuncs.com/{2}".format(Bucket, settings.REGION_ID, img_name)



















