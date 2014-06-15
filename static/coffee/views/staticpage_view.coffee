class sm8.views.StaticPage extends Backbone.View
    el: "#middle"

    initialize: ->
        @render()

    render: ->
        @$el.html @model.get 'content'