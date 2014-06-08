class sm8.views.Posts extends Backbone.View
    el: "#middle"
    template: JST['static/eco/posts']

    events:
        "submit .create form": "create_post"

    initialize: ->
        @collection = new sm8.collections.Posts
        @collection.fetch reset: true

        @_render = @renderPosts

        @listenTo @collection, 'reset', @render
        @listenTo @collection, 'add', @render

        @listenTo sm8, "user_login", @toggle_create_form
        @listenTo sm8, "user_logout", @toggle_create_form

        sm8.router.on "route:showHashtag", @switch_to_hashtags
        sm8.router.on "route:showRecentPosts", @switch_to_recent_posts

    render: ->
        @_render()

    renderPosts: ->
        @$el.html @template title: "Recent posts"

        for post in @collection.models
            @renderPost post

    renderHashtags: ->
        @$el.html @template title: "Browsing hashtag ##{@tag}"

        for post in @collection.models
            @renderPost post

    switch_to_hashtags: (tag) =>
        @tag = tag
        @_render = @renderHashtags
        @collection.url = -> "/api/hashtag/#{tag}/"
        @collection.fetch reset: true

    switch_to_recent_posts: =>
        @_render = @renderPosts
        @collection.url = "/api/post/"
        @collection.fetch reset: true

    toggle_create_form: ->
        if not sm8.user
            @$(".create").hide()
        else
            @$(".create").show()

    renderPost: (post) ->
        view = new sm8.views.Post model: post
        @$("#posts").append view.render().el

    create_post: (e) ->
        post = new sm8.models.Post
        post.save @$(".create form").form_data(),
            success: (model) =>
                @collection.add model, at: 0
                @$(".create form textarea").val ""
