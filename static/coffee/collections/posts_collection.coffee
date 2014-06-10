class sm8.collections.Posts extends Backbone.PageableCollection
    model: sm8.models.Post
    url: '/api/post/'
    hrefs: '/'

    state:
        pageSize: 10
        firstPage: 1
        currentPage: 1

    queryParams:
        totalPages: null
        totalRecords: null

    parseState: (resp, queryParams, state, options) ->
        return totalRecords: resp.count

    parseRecords: (resp, options) ->
        return resp.results
