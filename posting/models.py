import re
import os
import StringIO
from PIL import Image
import jsonfield

from django.db import models
from django.contrib.auth.models import User
from django.shortcuts import get_object_or_404
from django.core.files.uploadedfile import InMemoryUploadedFile

from posting.tasks import get_opengraph

# Create your models here.


class Post(models.Model):
    title = models.CharField(max_length=250)
    content = models.TextField()
    pub_date = models.DateTimeField(auto_now_add=True)
    parent = models.ForeignKey('self', null=True, related_name='comments')
    hashtags = models.ManyToManyField('Hashtag')
    user = models.ForeignKey(User)
    likes = models.ManyToManyField(User, related_name='liked')
    opengraph = jsonfield.JSONField(null=True, max_length=2000)

    class Meta:
        ordering = ['-pub_date']

    def save(self, *args, **kwargs):
        super(Post, self).save(*args, **kwargs)
        r = re.compile(r'#{1}(\w{1,120})')
        tags = set(tag.lower() for tag in r.findall(self.content))
        for tag in tags:
            try:
                self.hashtags.add(Hashtag.objects.get(title=tag))
            except Hashtag.DoesNotExist, e:
                self.hashtags.add(Hashtag.objects.create(title=tag))

        if not self.opengraph:
            r = re.compile(r'http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\(\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+')
            urls = r.findall(self.content)
            if urls:
                get_opengraph.delay(self, urls[0])

    def __unicode__(self):
        return self.title


class Hashtag(models.Model):
    title = models.CharField(max_length=120, unique=True)

    def __unicode__(self):
        return self.title


class Profile(models.Model):
    user = models.OneToOneField(User)
    city = models.CharField(max_length=250)
    site = models.URLField(max_length=250)
    avatar = models.ImageField(null=True, upload_to="avatar")
    background = models.ImageField(null=True, upload_to="background")
    avatar_thumb = models.ImageField(null=True, upload_to="avatar")
    background_thumb = models.ImageField(null=True, upload_to="background")


    def save(self, *args, **kwargs):
        if self.avatar:
            self.avatar_thumb = self.make_thumbnail(self.avatar)
        if self.background:
            self.background_thumb = self.make_thumbnail(self.background, size=(945, 220))
        super(Profile, self).save(*args, **kwargs)

    def make_thumbnail(self, image, size=(160, 160)):
        W, H = map(float, size)
        pil_img = Image.open(image)
        width, height = pil_img.size
        w = width
        h = H * (w/W)
        if h > height:
            h = height
            w = W * (h/H)

        left = int((width-w)/2)
        top = int((height-h)/2)
        thumb = pil_img.crop((left, top, int(w+left), int(h+top)))
        thumb.thumbnail(size, Image.ANTIALIAS)
        thumb_io = StringIO.StringIO()
        thumb.save(thumb_io, 'JPEG')
        return InMemoryUploadedFile(thumb_io, None, os.path.split(image.path)[-1], 'image/jpeg', thumb_io.len, None)


class StaticPage(models.Model):
    """Simplified version of django Flatpages"""
    codename = models.CharField(max_length=200, unique=True)
    content = models.TextField()
