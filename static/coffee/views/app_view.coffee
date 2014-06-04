class app.AppView extends Backbone.View
    el: "#app_container"

    initialize: ->
        @collection = new app.PostCollection
        @collection.fetch reset: true
        @render()

        @listenTo @collection, 'reset', @render


    render: ->
        for post in @collection.models
            @renderPost(post)

    renderPost: (post) ->
        view = new app.PostView model: post
        @$("#posts").append view.render().el
