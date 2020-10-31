from django.conf.urls import url

from django.conf import settings
from django.views.static import serve

from . import views

urlpatterns = [
    url(r'^hello/', views.hello),
    url(r'^test$',views.test),
    url(r'^files$',views.files),
    url(r'^static/(?P<path>.*)$', serve, {'document_root': settings.MEDIA_ROOT}),
    url(r'^updateKey$',views.updateKey),
]

