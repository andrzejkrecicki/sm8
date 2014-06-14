from rest_framework import serializers

from posting.models import Post, Hashtag
from sm8.serializers import UserSerializer


class CommentSerializer(serializers.ModelSerializer):
    user = UserSerializer(read_only=True)
    likes = UserSerializer(many=True, read_only=True)
    parent = serializers.PrimaryKeyRelatedField(required=False)

    class Meta:
        model = Post
        fields = ('id', 'user', 'content', 'pub_date', 'likes', 'parent')
        depth = 1


class PostSerializer(CommentSerializer):
    comments = CommentSerializer(many=True, read_only=True)

    class Meta:
        model = Post
        fields = ('id', 'user', 'content', 'pub_date', 'likes', 'comments', 'parent')
        depth = 1


class HashtahSerializer(serializers.ModelSerializer):
    class Meta:
        model = Hashtag
        fields = ('id', 'title',)
