window.sm8 = 
    models: {}
    collections: {}
    views: {}
    routers: {}
    user: null

    initialize: ->
        (new sm8.models.User).fetch
            success: (model, response, options) =>
                if model.id
                    sm8.user = new sm8.models.User response
                else
                    sm8.user = null
                sm8.right_sidebar.render()
            error: (model, response, options) =>
                sm8.user = null
                sm8.right_sidebar.render()

        sm8.app = new sm8.views.App
        sm8.right_sidebar = new sm8.views.RightSidebar

    close_dialogs: ->
        return unless sm8.dialog_view
        sm8.dialog_view.undelegateEvents()
        sm8.dialog_view.$el.removeData().unbind()
        sm8.dialog_view.remove()
        Backbone.View::remove.call(sm8.dialog_view)

$ ->
    sm8.initialize()