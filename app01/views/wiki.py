from django.shortcuts import render, redirect, HttpResponse
from django import views
from app01 import models
from app01.myform import wiki
from django.urls import reverse
from django.http import JsonResponse


class WiKi(views.View):
    """ wiki首页 """
    def get(self, request, pro_id):
        wiki_id = request.GET.get('wiki_id')
        wiki_obj = models.Wiki.objects.filter(id=wiki_id).first()
        return render(request, "app01/wiki.html", {'wiki_obj': wiki_obj})


class WikiAdd(views.View):
    def get(self, request, pro_id):
        form = wiki.WiKiModelForm(request)
        return render(request, "app01/wiki_add.html", {"form": form})

    def post(self, request, pro_id):
        form = wiki.WiKiModelForm(request, request.POST)
        if form.is_valid():
            form.instance.project_id = pro_id
            print(form.clean())
            form.save()
            url = reverse('app01:wiki', kwargs={'pro_id': pro_id})
            return redirect(url)
        return render(request, 'app01/wiki_add.html', {"form": form})


def wiki_data(request, pro_id):
    data = models.Wiki.objects.filter(project_id=pro_id).values('id', 'title', 'parent_id').order_by('deepth')
    print(data)
    return JsonResponse({'status': True, 'data': list(data)})



