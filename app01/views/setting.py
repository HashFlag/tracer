from django.shortcuts import render
from django import views


class Setting(views.View):
    def get(self, request, pro_id):
        return render(request, "app01/settings.html")

    def post(self, request, pro_id):
        return
