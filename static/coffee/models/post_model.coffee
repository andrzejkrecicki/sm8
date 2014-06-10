class sm8.models.Post extends Backbone.Model
    url: '/api/post/'
    defaults:
        title: "Default title"
        content: "Lorem ipsum dolor sit amet"

    initialize: ->
        for comment, i in @attributes.comments or []
            @attributes.comments[i] = new sm8.models.Post comment