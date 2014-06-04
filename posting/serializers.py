from rest_framework import serializers

from posting.models import Post, Hashtag


class PostSerializer(serializers.ModelSerializer):
    user = serializers.Field(source='user.username')
    class Meta:
        model = Post
        fields = ('id', 'user', 'title', 'content', 'pub_date',)


class HashtahSerializer(serializers.ModelSerializer):
    class Meta:
        model = Hashtag
        fields = ('id', 'title',)
