from rest_framework import serializers
from django.contrib.auth.models import User

from posting.models import Profile


class ProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = Profile
        fields = ('city', 'site', 'avatar', 'background')

class UserSerializer(serializers.ModelSerializer):
    profile = ProfileSerializer()
    class Meta:
        model = User
        fields = ('id', 'username', 'first_name', 'last_name', 'profile',)
