from django.conf.urls import url
from app01 import views
urlpatterns = [
    url(r'^login/', views.Login.as_view()),
]










