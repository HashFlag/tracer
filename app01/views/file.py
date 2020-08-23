import json
from django.shortcuts import render
from django import views
from app01 import models
from app01.myform.file import FileModelForm
from django.http import JsonResponse
from libs.aliyun.oss import delete_file, delete_files, credential
from django.views.decorators.csrf import csrf_exempt


class File(views.View):
    """ 文件操作首页效果 """
    def parents(self, request):
        folder_id = request.GET.get('folder_id', '')
        parent_obj = None
        if folder_id.isdecimal():
            parent_obj = models.FileRepository.objects.filter(
                id=int(folder_id),
                file_type=2,
                project=request.tracer_obj.project
            ).first()
        return parent_obj

    def get(self, request, pro_id):
        """ 首页效果 """
        parent_obj = self.parents(request)
        breadcrumb_list = []
        parent = parent_obj
        while parent:  # 面包屑操作
            breadcrumb_list.insert(0, {'id': parent.id, 'name': parent.name})
            parent = parent.parent
        form = FileModelForm(request, parent_obj)
        queryset = models.FileRepository.objects.filter(
            project=request.tracer_obj.project,
        )
        if parent_obj:
            print(32)
            file_obj_list = queryset.filter(parent=parent_obj).order_by("-file_type")
        else:
            file_obj_list = queryset.filter(parent__isnull=True).order_by("-file_type")
        return render(request, "app01/file.html", {
            "form": form,
            "file_obj_list": file_obj_list,
            "breadcrumb_list": breadcrumb_list
        })

    def edits(self, request):
        fid = request.POST.get('fid', '')
        edit_obj = None
        if fid.isdecimal():
            edit_obj = models.FileRepository.objects.filter(
                id=int(fid),
                file_type=2,
                project=request.tracer_obj.project
            ).first()
        return edit_obj

    def post(self, request, pro_id):
        """ 文件/文件夹增改 """
        edit_obj = self.edits(request)
        parent_obj = self.parents(request)
        if edit_obj:
            # 表示编辑
            form = FileModelForm(request, parent_obj, request.POST, instance=edit_obj)
        else:
            # 表示添加
            form = FileModelForm(request, parent_obj, request.POST)
        if form.is_valid():
            form.instance.project = request.tracer_obj.project
            form.instance.file_type = 2
            form.instance.parent = parent_obj
            form.instance.update_user = request.tracer_obj.user_obj
            form.save()
            return JsonResponse({'status': True, })
        else:
            return JsonResponse({'status': False, "error_msg": form.errors})


class FileDelete(views.View):
    """ 文件/文件夹的删除 """
    def get(self, request, pro_id):
        fid = request.GET.get("fid")
        delete_obj = models.FileRepository.objects.filter(
            id=fid,
            project=request.tracer_obj.project
        ).first()
        if delete_obj.file_type == 1:
            # 文件删除
            # 删除oss中的文件
            delete_file(request.tracer_obj.project.bucket, delete_obj.key)
            # 归还空间
            request.tracer_obj.project.use_space -= delete_obj.file_size
            request.tracer_obj.project.save()
            # 删除数据库中的文件信息
            delete_obj.delete()
            return JsonResponse({'status': True})

        else:
            # 文件夹删除
            total_size = 0
            key_list = []
            folder_list = [delete_obj, ]
            for folder in folder_list:
                child_list = models.FileRepository.objects.filter(
                    project=request.tracer_obj.project,
                    parent=folder
                ).order_by("-file_type")
                for child in child_list:
                    if child.file_type == 2:
                        folder_list.append(child)
                    else:
                        total_size += child.file_size
                        key_list.append({'Key': child.key})
            # delete_file('bzboy-tracer', '202007192.jpg')
            if key_list:
                # 删除文件
                delete_files(request.tracer_obj.project.bucket, key_list)
            # 归还空间
            request.tracer_obj.project.use_space -= total_size
            request.tracer_obj.project.save()

            delete_obj.delete()
            return JsonResponse({'status': True})


@csrf_exempt
def cos_credential(request, pro_id):
    """ 临时凭证与文件上传验证 """
    total_size = 0
    file_list = json.loads(request.body.decode('utf-8'))
    # 总空间大小
    per_project_space = request.tracer_obj.price_policy.project_space * 1024 * 1024 * 1024
    # 但文件大小M,换算成 B
    per_file_size = request.tracer_obj.price_policy.per_file_size
    for file in file_list:
        if file.get('size') > per_file_size*1024*1024:
            msg = "{}文件超出限制(最大为{}M),如需继续上传，请升级为高级用户！".format(file.get('name'), per_file_size)
            return JsonResponse({'status': False, 'error': msg})
        total_size += file.get('size')
    if request.tracer_obj.project.use_space + total_size > per_project_space:
        msg = '空间大小总和已经超限制，如需继续上传，请升级为高级用户！！'
        return JsonResponse({'status': False, 'error': msg})
    data_dict = credential(request.tracer_obj.project.region)
    data_dict['status'] = True
    data_dict['bucket'] = request.tracer_obj.project.bucket
    data_dict['region'] = request.tracer_obj.project.region
    return JsonResponse(data_dict)











