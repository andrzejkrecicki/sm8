from django.conf import settings
from django.conf.urls import url, patterns


urlpatterns = patterns('',
    url(r'^$', 'frontend.views.core', name='front_core'),
)