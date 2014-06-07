class sm8.routers.DefaultRouter extends Backbone.Router
    initialize: ->
        @route /^\/?$/, "showRecentPosts"
        @route /^hashtag\/(\w+)\/$/, "showHashtag"