import hashlib
from django.conf import settings


def set_md5(value):
    """ MD5加盐加密 """
    md5_obj = hashlib.md5(settings.SECRET_KEY.encode('utf-8'))
    md5_obj.update(value.encode('utf-8'))
    return md5_obj.hexdigest()






