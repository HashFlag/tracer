import os

if __name__ == '__main__':
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "tracer.settings")
    import django
    django.setup()
    num = 1
    from app01 import models

    # models.PricePolicy.objects.create(
    #     catogory=1,
    #     title='免费版',
    #     price=0,
    #     project_num=5,
    #     project_member=3,
    #     project_space=50,
    #     per_file_size=5,
    # )
    #
    # models.PricePolicy.objects.create(
    #     catogory=2,
    #     title='VIP',
    #     price=100,
    #     project_num=50,
    #     project_member=30,
    #     project_space=500,
    #     per_file_size=50,
    # )
    #
    # models.PricePolicy.objects.create(
    #     catogory=3,
    #     title='SVIP',
    #     price=200,
    #     project_num=500,
    #     project_member=300,
    #     project_space=5000,
    #     per_file_size=500,
    # )

    for i in range(10):
        dicts = {
            'name': '打豆豆%s' % (num,),
            'color': 1,
            'desc': '除了打豆豆%s，就是打豆豆%s' % (num, num,),
            'use_space': 0,
            'star': False,
            'create_id': 1,
            'join_count': 1,
            'create_time': '',
        }
        models.Project.objects.create(**dicts)
        num += 1
    print(models.UserInfo.objects.all())











