class sm8.views.Post extends Backbone.View
    tagName: "div"
    template: JST['static/eco/post']
    disabled: false

    events:
        "click .reply": "show_reply_form"
        "submit .reply_form": "send_reply"

    initialize: ->
        events = {}
        events["click .vote-#{@model.id}"] = "vote"
        @delegateEvents _.extend @events, events
        @vote = sm8.login_required this, @vote
        @send_reply = sm8.login_required this, @send_reply

        for comment, i in @model.attributes.comments or []
            @model.attributes.comments[i] = new sm8.models.Post comment

    render: ->
        @$el.html @template @model.toJSON()
        for comment in @model.get('comments') or [] by -1
            comment.parent = comment.parent or this
            view = new sm8.views.Post model: comment
            @$(".comments").append view.render().el
        return this

    vote: ->
        return if @disabled
        if @model.get('likes').filter((x) -> x.id == sm8.user.id).length
            @comment_tooltip "You have voted on this post before."
            return

        if @model.get('user') == sm8.user.get('username')
            @comment_tooltip "You cannot vote on your own posts."
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


    comment_tooltip: (text) ->
        @$(".vote-#{@model.id}").tooltip
            title: text
        .tooltip "show"

    show_reply_form: ->
        @$(".reply_form").show().find("textarea").focus()

    send_reply: ->
        reply = new sm8.models.Post
        reply.save @$(".reply_form form").form_data(),
            success: (model) =>
                @model.get('comments').unshift model
                @render()