class sm8.views.Settings extends Backbone.View
    el: "#middle"
    template: JST['static/eco/settings']

    events:
        "submit .profile_settings": "submit_settings"
        "submit .profile_images": "submit_images"

    render: ->
        @$el.html @template()

    generic_callback: (panel, alert_type, msg) ->
        return ->
            @$("##{panel} .status").html("").append alert = $("<div/>")
            alert.html "<div class='alert #{alert_type}'><a class='close' data-dismiss='alert'>×</a><span>#{msg}</span></div>"
            alert.alert()
            @$(".fa.fa-refresh").hide()

    generic_success_callback: (panel, swap_user=true) ->
        return (model, response, options) =>
            @generic_callback(panel, "alert-success", "Updated successfully")()
            sm8.user = model if swap_user

    generic_error_callback: (panel) ->
        return (model, response, options) =>
            @generic_callback(panel, "alert-danger", "Your form is invalid")()


    submit_settings: ->
        $form = @$(".profile_settings")
        @$(".fa.fa-refresh").show()
        @$(":hidden[name=csrfmiddlewaretoken]").val sm8.csrftoken
        user = new sm8.models.User sm8.user.attributes
        $.extend user.attributes, $form.form_data()
        user.save url: "/api/user/#{sm8.user.id}/",
            success: @generic_success_callback("general")
            error: @generic_error_callback("general")
    
    submit_images: ->
        $form = @$(".profile_images")
        @$(".fa.fa-refresh").show()
        @$(":hidden[name=csrfmiddlewaretoken]").val sm8.csrftoken
        formData = new FormData $form[0]
        $.ajax
            url: "/api/profile/#{sm8.user.id}/"
            type: 'PATCH'
            data: formData
            cache: false
            contentType: false
            processData: false
            success: @generic_success_callback("images", false)
            error: @generic_error_callback("images")