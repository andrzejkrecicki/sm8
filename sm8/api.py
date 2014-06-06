from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.models import User
from rest_framework import viewsets, permissions
from rest_framework.routers import DefaultRouter
from rest_framework.response import Response

from posting.serializers import PostSerializer, HashtahSerializer
from posting.models import Post, Hashtag
from sm8.serializers import UserSerializer


class PostViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Post.objects.all()
    serializer_class = PostSerializer
    permission_classes = (permissions.IsAuthenticatedOrReadOnly,)

    def pre_save(self, obj):
        obj.user = self.request.user


class HashtagViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Hashtag.objects.all()
    serializer_class = HashtahSerializer


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