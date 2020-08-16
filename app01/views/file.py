from django.shortcuts import render
from django import views
from app01 import models
from app01.myform.file import FileModelForm
from django.http import JsonResponse


class File(views.View):
    """ 文件操作 """
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
        parent_obj = self.parents(request)
        breadcrumb_list = []
        parent = parent_obj
        while parent:  # 面包屑操作
            breadcrumb_list.insert(0, {'id': parent.id, 'name': parent.name})
            parent = parent.parent
        form = FileModelForm(request, parent_obj)
        if parent_obj:
            file_obj_list = models.FileRepository.objects.filter(
                parent=parent_obj
            ).order_by("-file_type")
        else:
            file_obj_list = models.FileRepository.objects.filter(
                parent__isnull=True
            ).order_by("-file_type")
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







