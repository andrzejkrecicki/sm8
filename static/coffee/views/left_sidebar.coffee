class sm8.views.LeftSidebar extends Backbone.View
    el: "#left_menu"
    template: JST['static/eco/left_sidebar']

    initialize: ->
        @listenTo sm8, "user_login", @render
        @listenTo sm8, "user_logout", @render

    render: ->
        @$el.html @template()
        return this
