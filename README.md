Behold **sm8**
=========

sm8 is microblogging, social-networking service that allows users to shere content, vote and comment them to determine its position in popularity ranking. Entries itself are organized by hashtags. *(sm8 is by the way a catchy pun for "soulmate" since it's social-network app)*

------
<h2>Technology abstract</h2>
  - Backend
    - [django 1.6]
    - [django-rest-framework]
    - [django-pipeline] improved by [django-pipeline-eco]
    - [django-recaptcha]
    - [django-south]
    - [celery]
    - [memcached]
    - [pillow]
    - [opengraph]
    - python, virtualenv, git... (doh!)
  - Frontend
    - [backbone] enhanced by [backbone.paginator 2.0]
    - [bootstrap]
    - [coffeescript]
    - [sass]
    - [eco]
    - [moment.js]
    - [font-awesome]
    - [jquery]
    - [underscore]
    - [Google Fonts API]


[django 1.6]:https://www.djangoproject.com/
[django-rest-framework]:http://www.django-rest-framework.org/
[django-pipeline]:https://django-pipeline.readthedocs.org/en/latest/
[django-pipeline-eco]:https://github.com/vshjxyz/django-pipeline-eco
[django-south]:http://south.aeracode.org/
[django-recaptcha]:https://github.com/praekelt/django-recaptcha
[celery]:http://www.celeryproject.org/
[memcached]:https://github.com/linsomniac/python-memcached
[pillow]:https://github.com/python-pillow/Pillow
[opengraph]:https://pypi.python.org/pypi/opengraph/0.5
[backbone]:http://backbonejs.org/
[backbone.paginator 2.0]:https://github.com/backbone-paginator/backbone.paginator
[bootstrap]:http://getbootstrap.com/
[coffeescript]:http://coffeescript.org/
[sass]:http://sass-lang.com/
[eco]:https://github.com/sstephenson/eco
[moment.js]:http://momentjs.com/
[font-awesome]:http://fontawesome.io/
[jquery]:http://jquery.com/
[underscore]:http://underscorejs.org/
[Google Fonts API]:http://www.google.com/fonts

<h2>Features showcase</h2>
- 100% SPA
- RESTful API
- responsive design
- automatic URLs detection for asynchronous [opengraph] preview generation with [celery] tasks
- popular recent discussions - cached by [memcached]
- support for static pages
- reCAPTCHA protected users registration
- configurable profile fields, avatars and timeline background photo
- browsable user profiles
- posting, commenting, voting
- browsable hashtags
- pagination via [backbone.paginator 2.0]

##Concept overview##
<h3>html core</h3>
Application document structure is intended to be as tiny as possible and contain only necessary core, identical for all paths:
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="csrf-token" content="ALlDmq8fq44sYZpRc842Foh8vmsO3aik">
    <meta name="recaptcha_public" content="6LduFvUSAAAAAFJZALp8_T5V8kLKR3TTZeCV2jmL">
    <title></title>
    <link href="/static/css/all.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <div id="app_container">
        <div class="container">
            <div class="row">
                <div class="side_menu col-md-1">
                    <div class="row" id="left_menu">
                    </div>
                </div>
                <div class="side_menu col-md-1 col-md-push-10">
                    <div class="row" id="right_menu">
                    </div>
                </div>
                <div class="content col-md-10 col-md-pull-1">
                    <div id="middle"></div>
                </div>
            </div>
        </div>
    </div>
    <script type="application/javascript" src="/static/all.js" charset="utf-8"></script>
</body>
</html>
```
All required style-sheets and scripts are glued together, minified and loaded in separate calls or grabbed from browser cache if it's possible. Data is not prefetched to allow further varnish-like caching.


<h3>Design</h3>
Application design is inspired by Windows Phone metro style. Design itself contains absolutely no images (except for avatars and images posted by users obviously) it's built on pure sass style rules and [font-awesome] glyphs therefore it's super-lightweight and flexible.
<p>
<a href="http://i.imgur.com/JtajRHt.png" target="_blank">
    <img src="http://i.imgur.com/JtajRHt.png" style="height: 275px; margin: 5px;">
</a>
<a href="http://i.imgur.com/SlIZsqS.png" target="_blank">
    <img src="http://i.imgur.com/SlIZsqS.png" style="height: 275px; margin: 5px;">
</a><br>
<a href="http://i.imgur.com/1ZZPGzi.png" target="_blank">
    <img src="http://i.imgur.com/1ZZPGzi.png" style="height: 275px; margin: 5px;">
</a>
<a href="http://i.imgur.com/vzizueG.png" target="_blank">
    <img src="http://i.imgur.com/vzizueG.png" style="height: 275px; margin: 5px;">
</a>
<br><i><small>[click for larger preview]</small></i></p>
Full responsiveness and user friendliness comes from [bootstrap]:
<p>
<a href="http://i.imgur.com/xP9tsT1.png" target="_blank">
    <img src="http://i.imgur.com/xP9tsT1.png" style="height: 275px; margin: 5px;">
</a>
<br><i><small>[click for larger preview]</small></i></p>


<h3>Code</h3>
Since both [backbone] and [coffeescript] are designed by the same person - Jeremy Ashkenas, their combination in same application turns out to be extraordinarily productive and incredibly readable:
```coffeescript
class sm8.views.Post extends Backbone.View
    tagName: "div"
    template: JST['static/eco/post']
    disabled: false

    events:
        "click .reply": "show_reply_form"
        "submit .reply_form": "send_reply"

    render: ->
        @$el.html @template @model.toJSON()
        for comment in @model.get('comments') or [] by -1
            comment.parent or = this
            view = new sm8.views.Post model: comment
```
To spread coffeescript presence, *embedded coffeescript* also known as [eco] was chosen as templating language:
```html
<h4 class="media-heading"><i class="fa fa-user"></i> <a href="/user/<%= @user.username %>/"><%= @user.username %></a> </h4>
<i class="fa fa-calendar"></i> <%= moment(@pub_date).fromNow() %>
<% if @opengraph: %>
    <div class="og">
        <% if @opengraph.image: %>
            <a href="<%= @opengraph.url %>" target="_blank"><img src="<%= @opengraph.image %>" class="og-img"></a>
        <% else if @opengraph.video: %>
            <iframe width="560" height="315" src="<%= @opengraph.video %>" frameborder="0" allowfullscreen></iframe>
        <% end %>
        <h4><a href="<%= @opengraph.url %>" target="_blank"><%= @opengraph.title %></a></h4>
        <p><%= @opengraph.description %></p>
        <p class="site-title"><%= @opengraph.site_name %></p>
    </div>
<% end %>
<p><%= @safe insert_hashtag_hrefs insert_http_hrefs @content %></p>
<div class="footer">
    <% if not @parent: %>
        <div><span class="clickable reply"><i class="fa fa-reply"></i> Reply</span></div>
    <% end %>
    <div><span class="clickable vote-<%= @id %>"><i class="fa fa-thumbs-o-up"></i>x<%= @likes.length %> votes</span></div>
    <% if @comments?.length: %>
        <div><i class="fa fa-comments-o"></i>x<span><%= @comments.length %> comments</span></div>
    <% end %>
</div>
```

<h3>Installation</h3>
 1. clone repository:
        ```git clone https://github.com/andrzejkrecicki/sm8.git```

 2. install requirements:
        ```pip install -r requirements/common.txt```

 3. make sure you have some message broker already running
 4. install coffeescript 1.7.1

License
----
    MIT License