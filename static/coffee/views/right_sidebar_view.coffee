class sm8.views.RightSidebar extends Backbone.View
    el: "#right_menu"
    template: JST['static/eco/right_sidebar']

    events:
        "click .login_logout": "login_logout"

    initialize: ->
        @render()

    render: ->
        @$el.html @template()
        return this

    login_logout: (e) ->
        e.preventDefault()
        sm8.close_dialogs()

        if not sm8.user
            $("body").append sm8.dialog = $ "<div/>", id: "dialog"
            sm8.dialog_view = new sm8.views.Login
            sm8.dialog_view.render()
        else
            $.ajax
                url: "api/logout/"
                success: ->
                    sm8.user = null
                    sm8.right_sidebar.render()
