class app.PostView extends Backbone.View
    tagName: "div"
    className: "post"
    template: JST['static/eco/post']

    render: ->
        @$el.html @template @model.toJSON()
        return this
