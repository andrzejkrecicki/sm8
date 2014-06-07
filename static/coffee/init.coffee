window.sm8 = 
    models: {}
    collections: {}
    views: {}
    routers: {}
    user: null

    initialize: ->
        sm8.router = new sm8.routers.DefaultRouter
        $("body").on "click", "a", (e) ->
            sm8.router.navigate $(@).attr("href"), trigger: true
            e.preventDefault()

        Backbone.history.start pushState: true

        (new sm8.models.User).fetch
            success: (model, response, options) ->
                if model.id
                    sm8.user = new sm8.models.User response
                else
                    sm8.user = null
                sm8.right_sidebar.render()
            error: (model, response, options) ->
                sm8.user = null
                sm8.right_sidebar.render()

        sm8.posts_view = new sm8.views.Posts
        sm8.right_sidebar = new sm8.views.RightSidebar

    close_dialogs: ->
        return unless sm8.dialog_view
        sm8.dialog_view.undelegateEvents()
        sm8.dialog_view.$el.removeData().unbind()
        sm8.dialog_view.remove()
        Backbone.View::remove.call(sm8.dialog_view)

$ ->
    sm8.initialize()