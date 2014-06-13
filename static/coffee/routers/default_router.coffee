class sm8.routers.DefaultRouter extends Backbone.Router
    initialize: ->
        @route /^\/?$/, "showRecentPosts"
        @route /^hashtag\/(\w+)\/$/, "showHashtag"
        @route /^settings\/$/, "showSettings", @showSettings

    showSettings: ->
        if not sm8.user
            @navigate "/"
            return
        sm8.settings_view = new sm8.views.Settings
        sm8.settings_view.render()