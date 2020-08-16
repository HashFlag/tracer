from django.db import models
# Create your models here.


class UserInfo(models.Model):
    """ 用户表 """
    username = models.CharField(max_length=32, verbose_name="用户名", unique=True)
    phone = models.CharField(max_length=11, verbose_name="手机号", unique=True)
    email = models.EmailField(max_length=32, verbose_name="邮箱", unique=True)
    password = models.CharField(max_length=32, verbose_name="密码")


class PricePolicy(models.Model):
    """ 价格策略表 """
    choices = (
        (1, '免费版'),
        (2, 'VIP'),
        (3, 'SVIP')
    )
    catogory = models.SmallIntegerField(choices=choices, default=1,
                                        verbose_name="收费类型")
    title = models.CharField(verbose_name="标题", max_length=64, null=True, blank=True)
    price = models.PositiveIntegerField(verbose_name="价格")  # 正整数
    project_num = models.PositiveIntegerField(verbose_name="项目数量")
    project_member = models.PositiveIntegerField(verbose_name="项目成员人数")
    project_space = models.PositiveIntegerField(
        verbose_name="每个项目空间", help_text="单位是M")
    per_file_size = models.PositiveIntegerField(
        verbose_name="单文件大小",  help_text="单位是M")


class Transaction(models.Model):
    """ 购买记录 """
    status_choices = (
        (1, '未支付'),
        (2, '已支付')
    )
    status = models.SmallIntegerField(
        choices=status_choices, default=1, verbose_name="状态")
    order = models.CharField(verbose_name='订单号', max_length=64, unique=True)
    user = models.ForeignKey("UserInfo", verbose_name="用户")
    price_policy = models.ForeignKey("PricePolicy", verbose_name="价格策略")
    count = models.IntegerField(verbose_name="数量(年)", help_text="0表示无限期")
    price = models.IntegerField(verbose_name="实际支付价格")
    start_datetime = models.DateTimeField(verbose_name="开始时间", null=True, blank=True)
    end_datetime = models.DateTimeField(verbose_name="结束时间", null=True, blank=True)
    create_datetime = models.DateTimeField(verbose_name="创建时间", auto_now_add=True)


class Project(models.Model):
    """ 项目表 """
    choices = (
        (1, "#4EEE94"),
        (2, "#FFD700"),
        (3, "#90EE90"),
        (4, "#BF3EFF"),
        (5, "#FF34B3"),
        (6, "#FF6347"),
        (7, "#9370DB"),
    )
    name = models.CharField(verbose_name="项目名称", max_length=32)
    color = models.IntegerField(choices=choices, verbose_name="颜色", default=1)
    desc = models.CharField(verbose_name="项目描述", max_length=64,
                            null=True, blank=True)
    use_space = models.IntegerField(verbose_name="项目已用空间", default=0)
    star = models.BooleanField(verbose_name="星标", default=False)
    creator = models.ForeignKey('UserInfo', verbose_name="创建者")
    bucket = models.CharField(
        verbose_name="oss桶", max_length=60)
    region = models.CharField(verbose_name="oss区域", max_length=32)
    join_count = models.IntegerField(verbose_name="参与人数", default=1)
    create_time = models.DateTimeField(verbose_name="创建时间", auto_now_add=True)

    class Meta:
        unique_together = ["name", "creator"]


class ProjectUser(models.Model):
    """ 参与者 """
    project = models.ForeignKey("Project", verbose_name='项目')
    user = models.ForeignKey("UserInfo", verbose_name='参与者')
    star = models.BooleanField(verbose_name='星标', default=False)
    create_datetime = models.DateTimeField(verbose_name='加入时间', auto_now_add=True)


class Wiki(models.Model):
    """ wiki文件 """
    title = models.CharField(max_length=32, verbose_name='标题')
    content = models.TextField(verbose_name='内容')
    project = models.ForeignKey('Project', verbose_name="项目")
    parent = models.ForeignKey(
        'Wiki', null=True, blank=True,
        related_name='children', verbose_name="父文章"
    )
    deepth = models.IntegerField(verbose_name='深度', default=1)

    def __str__(self):
        return self.title


class FileRepository(models.Model):
    """ 文件库 """
    project = models.ForeignKey(verbose_name="项目", to="Project")
    file_type_choices = (
        (1, '文件'), (2, '文件夹'))
    file_type = models.SmallIntegerField(verbose_name='类型', choices=file_type_choices)
    name = models.CharField(verbose_name="文件夹名称", max_length=32, help_text="文件/文件夹名")
    # key 远程文件名
    key = models.CharField(verbose_name='文件存储在oss中的key', max_length=60, null=True, blank=True)
    file_size = models.IntegerField(verbose_name="文件大小", null=True, blank=True)
    file_path = models.CharField(verbose_name="文件路径", max_length=255, null=True, blank=True)
    parent = models.ForeignKey(verbose_name="父级目录", to='self', related_name="child", null=True, blank=True)
    update_user = models.ForeignKey(verbose_name='最近更新者', to="UserInfo")
    update_datetime = models.DateTimeField(verbose_name="更新时间", auto_now=True)









