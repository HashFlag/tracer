import uuid


def uuid_file_name(img_name):
    after_list = img_name.rsplit('.', 1)
    ret = uuid.uuid4()
    img_name = str(ret) + "." + after_list[-1]
    return img_name









