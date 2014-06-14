class sm8.views.Profile extends Backbone.View
    el :"#middle"
    template: JST['static/eco/profile']

    initialize: ->
        @collection = new sm8.collections.Posts
        @collection.url = "/api/user/#{@model.get('username')}/posts/"
        @collection.fetch reset: true

        @listenTo @collection, 'reset', @render

    render: ->
        @$el.html @template
            user: @model
            posts: @collection

        for post in @collection.models
            view = new sm8.views.Post model: post
            @$("#posts").append view.render().el
