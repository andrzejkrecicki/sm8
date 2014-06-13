class sm8.models.Login extends Backbone.Model
    urlRoot: '/api/login/'

    defaults:
        username: ''
        first_name: ''
        last_name: ''


class sm8.models.User extends Backbone.Model
    urlRoot: '/api/user/'
    url: ->
        orig_url = Backbone.Model::url.call(this)
        return orig_url + (if orig_url[-1..] is '/' then '' else '/')

    defaults:
        username: ''
        first_name: ''
        last_name: ''