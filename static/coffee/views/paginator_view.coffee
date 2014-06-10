class sm8.views.Paginator extends Backbone.View
    tagName: "ul"
    className: "pagination"
    template: JST['static/eco/paginator']

    events:
        "click a": "change_page"

    initialize: (@collection) ->

    render: ->
        if @collection.state.totalPages < 5
            min = @collection.state.firstPage
            max = @collection.state.totalPages
        else
            min = @collection.state.currentPage - 2
            max = @collection.state.currentPage + 2
            if min < @collection.state.firstPage
                max += @collection.state.firstPage - min
                min = @collection.state.firstPage
            if max > @collection.state.totalPages
                min -= max - @collection.state.lastPage
                max = @collection.state.lastPage

        @$el.html @template
            range: [min..max]
            current: @collection.state.currentPage
            first: @collection.state.firstPage
            last: @collection.state.lastPage
            collection: @collection

    change_page: (e) ->
        page = +e.target.attributes.page?.value
        return if @collection.state.currentPage is page or isNaN page
        @collection.getPage page,
            success: =>
                @collection.trigger "page_changed"
                