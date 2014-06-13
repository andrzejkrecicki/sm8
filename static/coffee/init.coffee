window.sm8 = $.extend {}, Backbone.Events,
    models: {}
    collections: {}
    views: {}
    routers: {}
    user: null
    csrftoken: $("meta[name=csrf-token]").attr 'content'
    recaptcha_public: $("meta[name=recaptcha_public]").attr 'content'

    initialize: ->
        $("body").on "click", "a:not([href^=#])", (e) ->
            sm8.router.navigate $(@).attr("href"), trigger: true
            e.preventDefault()

        $("body").on "submit", "form", (e) ->
            e.preventDefault()

        sm8.router = new sm8.routers.DefaultRouter
        Backbone.history.start pushState: true

        (new sm8.models.Login).fetch
            success: (model, response, options) ->
                if model.id
                    sm8.login new sm8.models.User response
                else
                    sm8.logout()
            error: (model, response, options) ->
                sm8.logout()

        sm8.posts_view = new sm8.views.Posts
        sm8.right_sidebar = new sm8.views.RightSidebar

    close_dialogs: ->
        return unless sm8.dialog_view
        sm8.dialog_view.undelegateEvents()
        sm8.dialog_view.$el.removeData().unbind()
        sm8.dialog_view.remove()
        Backbone.View::remove.call(sm8.dialog_view)

    login: (user) ->
        sm8.user = user
        sm8.trigger "user_login"

    logout: ->
        sm8.user = null
        sm8.router.navigate "/", trigger: true
        sm8.trigger "user_logout"

    login_required: (obj, callback) ->
        return ->
            return callback.call(obj) if sm8.user
            sm8.dialog_view = new sm8.views.Login
            sm8.dialog_view.render()

$.fn.extend
    form_data: ->
        data = {}
        form_data = $(@).serializeArray()
        for item in form_data
            if match = item.name.match(/(\w+)\[(\w+)\]/)
                data[match[1]] or = {}
                data[match[1]][match[2]] = item.value
            else
                data[item.name] = item.value
        return data

$.ajaxSetup
    crossDomain: false
    beforeSend: (xhr, settings) ->
        if not /^(GET|HEAD|OPTIONS|TRACE)$/.test settings.type
            xhr.setRequestHeader "X-CSRFToken", sm8.csrftoken
    complete: (result, xhr, status) ->
        sm8.csrftoken = document.cookie.match('csrftoken=([^;]+)')?[1] or sm8.csrftoken

$ ->
    sm8.initialize()