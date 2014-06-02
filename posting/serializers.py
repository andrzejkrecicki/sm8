from rest_framework import serializers

from posting.models import Post, Hashtag


class PostSerializer(serializers.ModelSerializer):
    class Meta:
        model = Post
        fields = ('title', 'content', 'pub_date',)


class HashtahSerializer(serializers.ModelSerializer):
    class Meta:
        model = Hashtag
        fields = ('title',)
