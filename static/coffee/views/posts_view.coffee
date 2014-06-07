class sm8.views.Posts extends Backbone.View
    el: "#middle"
    template: JST['static/eco/posts']

    initialize: ->
        @collection = new sm8.collections.Posts
        @collection.fetch reset: true
        
        @_render = @renderPosts
        @render()

        @listenTo @collection, 'reset', @render

        sm8.router.on "route:showHashtag", @switch_to_hashtags
        sm8.router.on "route:showRecentPosts", @switch_to_recent_posts

    render: ->
        @_render()

    renderPosts: ->
        @$el.html @template title: "Recent posts"

        for post in @collection.models
            @renderPost(post)

    renderHashtags: ->
        @$el.html @template title: "Browsing hashtag ##{@tag}"

        for post in @collection.models
            @renderPost(post)

    switch_to_hashtags: (tag) =>
        @tag = tag
        @_render = @renderHashtags
        @collection.url = -> "/api/hashtag/#{tag}/"
        @collection.fetch reset: true

    switch_to_recent_posts: =>
        @_render = @renderPosts
        @collection.url = "/api/post/"
        @collection.fetch reset: true


    renderPost: (post) ->
        view = new sm8.views.Post model: post
        @$("#posts").append view.render().el
