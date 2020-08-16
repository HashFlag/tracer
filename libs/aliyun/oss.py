import oss2
from django.conf import settings


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


def delete_bucket(bucket_name):
    """ 删除存储桶 """
    pass
















