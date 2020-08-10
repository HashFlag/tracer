from django.shortcuts import render
from django import views


class WiKi(views.View):
    def get(self, request, pro_id):
        return render(request, "app01/wiki.html")

