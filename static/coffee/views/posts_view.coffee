class sm8.views.Posts extends Backbone.View
    el: "#middle"
    template: JST['static/eco/posts']

    events:
        "submit .create form": "create_post"

    title: "Recent posts"

    initialize: ->
        @collection = new sm8.collections.Posts
        @collection.fetch reset: true

        @listenTo @collection, 'reset', @render
        @listenTo @collection, 'page_changed', @render
        @listenTo @collection, 'page_changed', sm8.scroll_to_top

        @listenTo sm8, "user_login", @toggle_create_form
        @listenTo sm8, "user_logout", @toggle_create_form

        sm8.router.on "route:showHashtag", @switch_to_hashtags
        sm8.router.on "route:showRecentPosts", @switch_to_recent_posts

    render: ->
        @$el.html @template
            title: @title
            collection: @collection

        for post in @collection.models
            view = new sm8.views.Post model: post
            @$("#posts").append view.render().el

        paginator = new sm8.views.Paginator @collection
        @$("#pagination").html paginator.render()

    switch_to_hashtags: (@tag) =>
        @title = "Browsing hashtag ##{@tag}"
        @collection.url = -> "/api/hashtag/#{tag}/"
        @collection.hrefs = "/hashtag/#{tag}/"
        @collection.state.currentPage = @collection.state.firstPage
        @collection.fetch reset: true

    switch_to_recent_posts: =>
        @title = "Recent posts"
        @collection.url = "/api/post/"
        @collection.hrefs = "/"
        @collection.state.currentPage = @collection.state.firstPage
        @collection.fetch reset: true

    toggle_create_form: ->
        if not sm8.user
            @$(".create").hide()
        else
            @$(".create").show()

    create_post: (e) ->
        post = new sm8.models.Post
        post.save @$(".create form").form_data(),
            success: (model) =>
                @collection.add model, at: 0
                @$(".create form textarea").val ""
