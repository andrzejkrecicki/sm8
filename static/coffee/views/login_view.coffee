class sm8.views.Login extends Backbone.View
    template: JST['static/eco/login_dialog']
    el: "#dialog"

    events:
        "submit form": "submit"
        "click .login_btn": "submit"

    render: ->
        @$el.html @template()
        @$("#loginModal").modal()
        return this

    submit: (e) ->
        e.preventDefault()
        return if @$(":submit").prop("disabled")
        @$(":submit").prop("disabled", true)
        @$(".fa.fa-refresh").show()
        data = {}
        form_data = @$("form").serializeArray()
        data[item.name] = item.value for item in form_data
        @login data

    login: (data) ->
        user = new sm8.models.User
        user.save data,
            success: (model, response, options) ->
                if model.id
                    sm8.user = new sm8.models.User response
                    @$("#loginModal").modal('hide')
                    sm8.right_sidebar.render()
                else
                    sm8.user = null
                @$(".fa.fa-refresh").hide()
                @$(":submit").prop("disabled", false)
            error: (model, response, options) ->
                @$(".status").html ""
                for error in response.responseJSON.errors
                    @$(".status").append alert = $("<div/>")
                    alert.html "<div class='alert alert-danger'><a class='close' data-dismiss='alert'>×</a><span>#{error}</span></div>"
                    alert.alert()

                sm8.user = null
                @$(".fa.fa-refresh").hide()
                @$(":submit").prop("disabled", false)
