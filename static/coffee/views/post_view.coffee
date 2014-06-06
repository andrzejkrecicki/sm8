class sm8.views.Post extends Backbone.View
    tagName: "div"
    className: "post"
    template: JST['static/eco/post']

    render: ->
        @$el.html @template @model.toJSON()
        return this
