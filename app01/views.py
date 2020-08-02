from django.shortcuts import render
from django import views
from app01 import mymodels
# Create your views here.


class Login(views.View):
    def get(self, request):
        UserInfo = mymodels.UserInfoFrom()
        # print("UserInfo:", UserInfo)
        return render(request, "login.html",
                      {'userinfo': UserInfo})



















