class sm8.routers.DefaultRouter extends Backbone.Router
    initialize: ->
        @route /^\/?$/, "showRecentPosts"
        @route /^hashtag\/(\w+)\/$/, "showHashtag"
        @route /^settings\/$/, "showSettings", @showSettings
        @route /^user\/([\w.@+-]+)\/$/, "showProfile", @showProfile

    showSettings: ->
        if not sm8.user
            @navigate "/"
            return
        sm8.settings_view = new sm8.views.Settings
        sm8.settings_view.render()

    showProfile: (username) ->
        profile = new sm8.models.User id: username
        profile.fetch
            success: ->
                sm8.profile_view = new sm8.views.Profile model: profile