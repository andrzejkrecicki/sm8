class sm8.views.RightSidebar extends Backbone.View
    el: "#right_menu"
    template: JST['static/eco/right_sidebar']

    events:
        "click .login_logout": "login_logout"
        "click .settings": "settings"

    initialize: ->
        @render()
        @listenTo sm8, "user_login", @render
        @listenTo sm8, "user_logout", @render

        @settings = sm8.login_required this, @settings

    render: ->
        @$el.html @template()
        return this

    login_logout: (e) ->
        e.preventDefault()

        if not sm8.user
            sm8.dialog_view = new sm8.views.Login
            sm8.dialog_view.render()
        else
            $.ajax
                url: "/api/logout/"
                success: ->
                    sm8.logout()
