from django.conf.urls import patterns, include, url

from django.contrib import admin
admin.autodiscover()

from sm8.api import router



urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'sm8.views.home', name='home'),
    # url(r'^blog/', include('blog.urls')),

    url(r'^api/', include(router.urls)),

    url(r'^admin/', include(admin.site.urls)),
)
