from django.shortcuts import render, redirect, HttpResponse
from django import views
from app01 import models
from app01.myform import wiki
from django.urls import reverse
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt, csrf_protect
# csrf_exempt装饰的接口，不会进行csrf_token认证，即便是全局配置配置了认证中间件
# csrf_protect装饰的接口，必须通过csrftoken认证，即便是全局没有配置认证中间件
from libs.aliyun import oss

class WiKi(views.View):
    """ wiki首页 """
    def get(self, request, pro_id):
        wiki_id = request.GET.get('wiki_id')
        wiki_obj = models.Wiki.objects.filter(id=wiki_id).first()
        return render(request, "app01/wiki.html", {'wiki_obj': wiki_obj})


class WikiAdd(views.View):
    """ 添加文件 """
    def get(self, request, pro_id):
        form = wiki.WiKiModelForm(request)
        return render(request, "app01/wiki_add.html", {"form": form})

    def post(self, request, pro_id):
        form = wiki.WiKiModelForm(request, request.POST)
        if form.is_valid():
            if form.instance.parent:
                form.instance.deepth = form.instance.parent.deepth + 1
            else:
                form.instance.deepth = 1
            form.instance.project_id = pro_id
            form.save()
            url = reverse('app01:wiki', kwargs={'pro_id': pro_id})
            return redirect(url)
        return render(request, 'app01/wiki_add.html', {"form": form})


class WikiEdit(views.View):
    """ 编辑文件 """
    def get(self, request, pro_id, wiki_id):
        wiki_obj = models.Wiki.objects.filter(id=wiki_id).first()
        form = wiki.WiKiModelForm(request, instance=wiki_obj)
        # todo wiki_obj不存在时报错提示信息和编辑添加合并待解决
        return render(request, "app01/wiki_add.html", {"form": form})

    def post(self, request, pro_id, wiki_id):
        # todo 编辑中有个文章子父集转换bug，待解决
        wiki_obj = models.Wiki.objects.filter(id=wiki_id).first()
        form = wiki.WiKiModelForm(request, request.POST, instance=wiki_obj)
        if form.is_valid():
            if form.instance.parent:
                form.instance.deepth = form.instance.parent.deepth + 1
            else:
                form.instance.deepth = 1
            form.instance.project_id = pro_id
            form.save()
            url = reverse('app01:wiki', kwargs={'pro_id': pro_id})
            path_url = "{0}?wiki_id={1}".format(url, wiki_id)
            return redirect(path_url)
        return render(request, 'app01/wiki_add.html', {"form": form})


def wiki_data(request, pro_id):
    """ 文章标题展示 """
    data = models.Wiki.objects.filter(project_id=pro_id).values('id', 'title', 'parent_id').order_by('deepth')
    return JsonResponse({'status': True, 'data': list(data)})


def wiki_delete(request, pro_id, wiki_id):
    """ 删除文件 """
    wiki_obj = models.Wiki.objects.filter(id=wiki_id).delete()
    url = reverse('app01:wiki', kwargs={'pro_id': pro_id})
    return redirect(url)


@csrf_exempt
def wiki_upload(request, pro_id):
    """ 图片上传 """
    ''' 响应给mdeditor的数据格式是固定的 '''
    result = {
        'success': 0,
        'message': None,
        'url': ''
    }
    # print(request.FILES)
    # 由于阿里云不支持django的文件上传格式（InMemoryUploadedFile）；
    # 所以需要.read读取字节文件进行上传操作
    img_obj = request.FILES.get("editormd-image-file").read()
    img_name = request.FILES.get("editormd-image-file").name
    url = oss.upload_file(img_name, img_obj)
    result['success'] = 1
    result['url'] = url
    return JsonResponse(result)









