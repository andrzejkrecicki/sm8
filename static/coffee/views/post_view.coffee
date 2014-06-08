class sm8.views.Post extends Backbone.View
    tagName: "div"
    className: "post"
    template: JST['static/eco/post']
    disabled: false

    events:
        "click .vote": "vote"

    initialize: ->
        @vote = sm8.login_required this, @vote

    render: ->
        @$el.html @template @model.toJSON()
        return this

    vote: ->
        return if @disabled
        if @model.get('likes').filter((x) -> x.id == sm8.user.id).length
            @$(".vote").tooltip
                title: "You have voted on this post before."
            .tooltip "show"
            return

        if @model.get('user') == sm8.user.get('username')
            @$(".vote").tooltip
                title: "You cannot vote on your own posts."
            .tooltip "show"
            return

        @disabled = true
        @$(".fa-thumbs-o-up").removeClass("fa-thumbs-o-up").addClass("fa-refresh fa-spin")
        $.ajax
            url: "#{@model.url}#{@model.id}/vote/"
            type: "POST"
            success: (model, response, options) =>
                @model = new sm8.models.Post model
                @render()
            complete: =>
                @disabled = false
                @$(".fa-refresh").removeClass("fa-refresh fa-spin").addClass("fa-thumbs-o-up")
