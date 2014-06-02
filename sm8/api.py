from rest_framework import viewsets
from rest_framework.routers import DefaultRouter

from posting.serializers import PostSerializer, HashtahSerializer
from posting.models import Post, Hashtag


class PostViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Post.objects.all()
    serializer_class = PostSerializer


class HashtagViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Hashtag.objects.all()
    serializer_class = HashtahSerializer



router = DefaultRouter()
router.register('post', PostViewSet)
router.register('hashtag', HashtagViewSet)