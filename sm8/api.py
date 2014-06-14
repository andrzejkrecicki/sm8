import re

from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.models import User
from django.shortcuts import get_object_or_404
from django.db.models import Q
from django import forms

from rest_framework import viewsets, permissions, mixins
from rest_framework.routers import DefaultRouter
from rest_framework.response import Response
from rest_framework.decorators import link, action
from rest_framework.parsers import FormParser, MultiPartParser

from posting.serializers import PostSerializer, HashtahSerializer
from posting.models import Post, Hashtag, Profile
from sm8.serializers import UserSerializer, ProfileSerializer
from sm8.forms import UserCreateForm


class IsOwnerOrReadOnly(permissions.BasePermission):
    def has_object_permission(self, request, view, obj):
        if request.method in permissions.SAFE_METHODS:
            return True
        try:
            return obj.user == request.user
        except AttributeError, e:
            try:
                return obj == request.user
            except AttributeError, e:
                return False


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
    queryset = Post.objects.all()
    serializer_class = PostSerializer

    def retrieve(self, request, pk):
        posts = Post.objects.filter((Q(parent=None) & Q(hashtags__title=pk)) | Q(comments__hashtags__title=pk)).distinct()
        page = self.paginate_queryset(posts)
        if page is not None:
            serializer = self.get_pagination_serializer(page)
        else:
            serializer = self.get_serializer(posts, many=True)
        return Response(serializer.data)


class UserViewSet(viewsets.ModelViewSet):
    serializer_class = UserSerializer
    model = User
    permission_classes = (permissions.IsAuthenticatedOrReadOnly, IsOwnerOrReadOnly)

    def retrieve(self, *args, **kwargs):
        user = get_object_or_404(User, username=kwargs.get('pk'))
        return Response(UserSerializer(user).data)

    @link()
    def posts(self, *args, **kwargs):
        user = get_object_or_404(User, username=kwargs.get('pk'))
        posts = user.post_set.filter(parent=None)
        self.serializer_class = PostSerializer
        page = self.paginate_queryset(posts)
        if page is not None:
            serializer = self.get_pagination_serializer(page)
        else:
            serializer = self.get_serializer(posts, many=True)
        return Response(serializer.data)


class ProfileViewSet(viewsets.ModelViewSet):
    serializer_class = ProfileSerializer
    model = Profile
    permission_classes = (permissions.IsAuthenticatedOrReadOnly, IsOwnerOrReadOnly)
    parser_classes = (FormParser, MultiPartParser,)

    def update(self, *args, **kwargs):
        profile = Profile.objects.get(pk=kwargs.get('pk'))
        for k, v in args[0].FILES.dict().iteritems():
            setattr(profile, k, v)
        profile.save()
        return Response(UserSerializer(profile.user).data)


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


class RegisterViewSet(viewsets.GenericViewSet):
    model = User
    permission_classes = (permissions.AllowAny,)

    def create(self, request):
        form = UserCreateForm(request.DATA)
        if form.is_valid():
            username = form.clean_username()
            password = form.clean_password2()
            user = form.save()
            Profile.objects.create(user=user)
            user = authenticate(username=username, password=password)
            login(request, user)
            return Response(UserSerializer(user).data)
        else:
            return Response({'errors': form.errors}, status=401)



class LogoutViewSet(viewsets.GenericViewSet):
    permission_classes = (permissions.AllowAny,)

    def list(self, request):
        logout(request)
        return Response({'data': 'ok'})



router = DefaultRouter()
router.register('post', PostViewSet)
router.register('hashtag', HashtagViewSet)
router.register('login', LoginViewSet)
router.register('logout', LogoutViewSet, base_name='')
router.register('register', RegisterViewSet)
router.register('user', UserViewSet)
router.register('profile', ProfileViewSet)