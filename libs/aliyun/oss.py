import oss2
import json
from django.conf import settings
from aliyunsdkcore import client
from oss2.models import BucketCors, CorsRule
from aliyunsdkcore.profile import region_provider
from aliyunsdksts.request.v20150401 import AssumeRoleRequest


def upload_file(img_name, img_obj, user_bucket="bzboy-tracer"):
    """ 文件上传 """
    # 阿里云主账号AccessKey拥有所有API的访问权限，风险很高。强烈建议您创建并使用RAM账号进行API访问或日常运维，请登录 https://ram.console.aliyun.com 创建RAM账号。
    auth = oss2.Auth(settings.ACCESSKEY_ID, settings.ACCESSKEY_SERECT)
    # Endpoint以北京为例，其它Region请按实际情况填写。
    bucket = oss2.Bucket(auth, 'http://oss-'+settings.REGION_ID+'.aliyuncs.com', user_bucket)
    bucket.put_object(img_name, img_obj)

    return "https://{0}.oss-{1}.aliyuncs.com/{2}".format(user_bucket, settings.REGION_ID, img_name)


def create_bucket(bucket_name, region="cn-beijing"):
    """ 创建存储桶 """

    # 阿里云主账号AccessKey拥有所有API的访问权限，风险很高。强烈建议您创建并使用RAM账号进行API访问或日常运维，请登录 https://ram.console.aliyun.com 创建RAM账号。
    auth = oss2.Auth(settings.ACCESSKEY_ID, settings.ACCESSKEY_SERECT)
    # 通过指定Endpoint和存储空间名称，您可以在指定的地域创建新的存储空间。Endpoint以杭州为例，其它Region请按实际情况填写。
    bucket = oss2.Bucket(auth, 'http://oss-'+region+'.aliyuncs.com', bucket_name)

    # 创建存储空间。
    # 如果需要在创建存储空间时设置存储类型、存储空间访问权限、数据容灾类型，请参考以下代码。
    # 以下以配置存储空间为标准存储类型，访问权限为公有读（PUBLIC_READ），数据容灾类型为同城冗余存储为例。
    bucketConfig = oss2.models.BucketCreateConfig(oss2.BUCKET_STORAGE_CLASS_STANDARD, oss2.BUCKET_DATA_REDUNDANCY_TYPE_ZRS)
    bucket.create_bucket(oss2.BUCKET_ACL_PUBLIC_READ, bucketConfig)

    # js跨域访问时的bucket权限配置
    rule = CorsRule(allowed_origins=['*'],
                    allowed_methods=['GET', 'HEAD', 'PUT', 'POST', 'DELETE'],
                    allowed_headers=['*'],
                    expose_headers=['ETag', 'x-oss-request-id'],
                    max_age_seconds=60)
    # 已存在的规则将被覆盖。
    bucket.put_bucket_cors(BucketCors([rule]))


def delete_file(bucket_name, file_name, region="cn-beijing"):
    """ 删除存储桶中的文件 """
    auth = oss2.Auth(settings.ACCESSKEY_ID, settings.ACCESSKEY_SERECT)
    bucket = oss2.Bucket(auth, 'http://oss-'+region+'.aliyuncs.com', bucket_name)

    # 删除文件。<yourObjectName>表示删除OSS文件时需要指定包含文件后缀在内的完整路径，例如abc/efg/123.jpg。
    bucket.delete_object(file_name)


def delete_files(bucket_name, file_list, region="cn-beijing"):
    """ 批量删除存储桶中的文件 """
    auth = oss2.Auth(settings.ACCESSKEY_ID, settings.ACCESSKEY_SERECT)
    bucket = oss2.Bucket(auth, 'http://oss-'+region+'.aliyuncs.com', bucket_name)

    # 删除文件。<yourObjectName>表示删除OSS文件时需要指定包含文件后缀在内的完整路径，例如abc/efg/123.jpg。
    # 批量删除文件。每次最多删除1000个文件。
    result = bucket.batch_delete_objects(file_list)
    # 打印成功删除的文件名。
    print('\n'.join(result.deleted_keys))


def delete_bucket(bucket):
    """ 删除存储桶 """
    pass


def credential(region="cn-beijing"):
    """ STS临时凭证授权 """
    # 构建一个阿里云client，用于发起请求
    # 构建阿里云client时需要设置AccessKey ID和AccessKey Secret
    REGIONID = region
    ENDPOINT = 'sts.'+region+'.aliyuncs.com'
    # 配置要访问的STS Endpoint
    region_provider.add_endpoint('Sts', REGIONID, ENDPOINT)
    # 初始化client
    clt = client.AcsClient(settings.ACCESSKEY_ID, settings.ACCESSKEY_SERECT, REGIONID)
    # 构建AssumeRole请求
    request = AssumeRoleRequest.AssumeRoleRequest()
    # 指定角色ARN
    request.set_RoleArn(settings.ROLE_ARN)
    # 设置会话名称，审计服务使用此名称区分调用者(自行设置)
    request.set_RoleSessionName('role-session-tracer')
    # 设置权限策略以进一步限制STS Token获取的权限
    # request.set_Policy('<policy>')
    # 发起请求，并得到响应
    response = clt.do_action_with_exception(request)
    response = json.loads(response)
    # print(response)
    result_dict = dict(
        AccessKeyId=response['Credentials']['AccessKeyId'],
        AccessKeySecret=response['Credentials']['AccessKeySecret'],
        SecurityToken=response['Credentials']['SecurityToken'],
        Expiration=response['Credentials']['Expiration'])

    return result_dict














