from django.shortcuts import render
from django import views


class Issues(views.View):
    def get(self, request, pro_id):
        return render(request, "app01/issues.html")

