from django.shortcuts import render
from django import views


class Statistics(views.View):
    def get(self, request, pro_id):
        return render(request, "app01/statistics.html")

