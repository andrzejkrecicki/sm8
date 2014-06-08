from rest_framework import serializers

from posting.models import Post, Hashtag
from sm8.serializers import UserSerializer

class PostSerializer(serializers.ModelSerializer):
    user = serializers.Field(source='user.username')
    likes = UserSerializer(many=True)

    class Meta:
        model = Post
        fields = ('id', 'user', 'title', 'content', 'pub_date', 'likes')


class HashtahSerializer(serializers.ModelSerializer):
    class Meta:
        model = Hashtag
        fields = ('id', 'title',)
