import re

from django.db import models
from django.contrib.auth.models import User
from django.shortcuts import get_object_or_404

# Create your models here.


class Post(models.Model):
    title = models.CharField(max_length=250)
    content = models.TextField()
    pub_date = models.DateTimeField(auto_now_add=True)
    parent = models.ForeignKey('self', null=True)
    hashtags = models.ManyToManyField('Hashtag')
    user = models.ForeignKey(User)

    class Meta:
        ordering = ['-pub_date']

    def save(self, *args, **kwargs):
        super(Post, self).save(*args, **kwargs)
        r = re.compile(r'#{1}(\w{1,120})')
        tags = set(r.findall(self.content))
        for tag in tags:
            try:
                self.hashtags.add(Hashtag.objects.get(title=tag))
            except Hashtag.DoesNotExist, e:
                self.hashtags.add(Hashtag.objects.create(title=tag))

    def __unicode__(self):
        return self.title


class Hashtag(models.Model):
    title = models.CharField(max_length=120, unique=True)

    def __unicode__(self):
        return self.title