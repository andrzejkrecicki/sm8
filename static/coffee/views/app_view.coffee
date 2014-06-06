class sm8.views.App extends Backbone.View
    el: "#app_container"

    initialize: ->
        @collection = new sm8.collections.Posts
        @collection.fetch reset: true
        @render()

        @listenTo @collection, 'reset', @render

    render: ->
        for post in @collection.models
            @renderPost(post)

    renderPost: (post) ->
        view = new sm8.views.Post model: post
        @$("#posts").append view.render().el
