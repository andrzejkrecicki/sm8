from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.models import User
from django.shortcuts import get_object_or_404
from django.db.models import Q

from rest_framework import viewsets, permissions
from rest_framework.routers import DefaultRouter
from rest_framework.response import Response
from rest_framework.decorators import link, action

from posting.serializers import PostSerializer, HashtahSerializer
from posting.models import Post, Hashtag
from sm8.serializers import UserSerializer


class IsOwnerOrReadOnly(permissions.BasePermission):
    def has_object_permission(self, request, view, obj):
        if request.method in permissions.SAFE_METHODS:
            return True
        return obj.user == request.user


class PostViewSet(viewsets.ModelViewSet):
    queryset = Post.objects.filter(parent=None)
    serializer_class = PostSerializer
    permission_classes = (permissions.IsAuthenticatedOrReadOnly, IsOwnerOrReadOnly)

    def pre_save(self, obj):
        obj.user = self.request.user

    @action(permission_classes=(permissions.IsAuthenticatedOrReadOnly,))
    def vote(self, request, pk):
        post = get_object_or_404(Post, pk=pk)
        if request.user != post.user:
            post.likes.add(request.user)
            post.save()
        return Response(PostSerializer(post).data)



class HashtagViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Hashtag.objects.all()
    serializer_class = HashtahSerializer

    def retrieve(self, request, pk):
        posts = Post.objects.filter((Q(parent=None) & Q(hashtags__title=pk)) | Q(comments__hashtags__title=pk))
        return Response(PostSerializer(posts, many=True).data)


class LoginViewSet(viewsets.ReadOnlyModelViewSet):
    model = User
    permission_classes = (permissions.AllowAny,)

    def list(self, request):
        if request.user and request.user.is_authenticated():
            return Response(UserSerializer(request.user).data)
        else:
            return Response({'errors': ['Not logged in']}, status=401)

    def create(self, request):
        if request.DATA:
            username = request.DATA.get('username')
            password = request.DATA.get('password')
            user = authenticate(username=username, password=password)
            if user:
                login(request, user)
                return Response(UserSerializer(request.user).data)
        return Response({'errors': ['Invalid name or password']}, status=401)



class LogoutViewSet(viewsets.ViewSet):
    permission_classes = (permissions.AllowAny,)

    def list(self, request):
        logout(request)
        return Response({'data': 'ok'})



router = DefaultRouter()
router.register('post', PostViewSet)
router.register('hashtag', HashtagViewSet)
router.register('login', LoginViewSet)
router.register('logout', LogoutViewSet, base_name='')