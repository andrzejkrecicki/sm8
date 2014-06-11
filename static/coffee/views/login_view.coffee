class sm8.views.Login extends Backbone.View
    template: JST['static/eco/login_dialog']
    el: "#dialog"

    events:
        "submit .login_form": "submit_login"
        "click .login_btn": "submit_login"
        "submit .register_form": "submit_registration"
        "click .register_btn": "submit_registration"

    initialize: ->
        sm8.close_dialogs()
        $("body").append @$el = sm8.dialog = $ "<div/>", id: "dialog"

    render: ->
        @$el.html @template()
        @captcha = Recaptcha.create sm8.recaptcha_public, "captcha",
            theme: "clean"
            callback: Recaptcha.focus_response_field
        @$("#loginModal").modal()
        return this

    submit_login: (e) ->
        e.preventDefault()
        return if @$(":submit").prop("disabled")
        @$(":submit").prop("disabled", true)
        @$(".fa.fa-refresh").show()
        @login @$(".login_form").form_data()

    submit_registration: (e) ->
        return if @$(":submit").prop("disabled")
        @$(":submit").prop("disabled", true)
        @$(".fa.fa-refresh").show()
        @register @$(".register_form").form_data()


    login: (data) ->
        user = new sm8.models.User
        user.save data,
            success: (model, response, options) ->
                if model.id
                    sm8.login new sm8.models.User response
                    @$("#loginModal").modal('hide')
                else
                    sm8.logout()
                @$(".fa.fa-refresh").hide()
                @$(":submit").prop("disabled", false)
            error: (model, response, options) ->
                @$(".status").html ""
                for error in response.responseJSON.errors
                    @$(".status").append alert = $("<div/>")
                    alert.html "<div class='alert alert-danger'><a class='close' data-dismiss='alert'>×</a><span>#{error}</span></div>"
                    alert.alert()

                sm8.logout()
                @$(".fa.fa-refresh").hide()
                @$(":submit").prop("disabled", false)

    register: (data) ->
        user = new sm8.models.User
        user.urlRoot = 'api/register/'
        user.save data,
            success: (model, response, options) ->
                if model.id
                    sm8.login new sm8.models.User response
                    @$("#loginModal").modal('hide')
            error: (models, response, options) ->
                Recaptcha.reload()
                @$(".alert").alert('close')
                for error, msg of response.responseJSON.errors
                    @$("[name=#{error}]").parent().parent().before alert = $("<div/>")
                    alert.addClass "alert alert-danger"
                    alert.html "<a class='close' data-dismiss='alert'>×</a><span>#{msg[0]}</span>"
                    alert.alert()
                @$(".fa.fa-refresh").hide()
                @$(":submit").prop("disabled", false)

