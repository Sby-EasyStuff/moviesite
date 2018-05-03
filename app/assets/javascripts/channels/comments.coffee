App.comments = App.cable.subscriptions.create "CommentsChannel",
  collection: -> $("[data-channel='comments']")

  connected: ->
    setTimeout =>
      @followCurrentMovie()
      @installPageChangeCallback()
    , 1000

  received: (data) ->
    @collection().append(data.comment) unless @userIsCurrentUser(data.comment)

  userIsCurrentUser: (comment) ->
    $(comment).attr('data-user-id') is $('meta[name=current-user]').attr('id')

  followCurrentMovie: ->
    if movieId = @collection().data('movie-id')
      @perform 'follow', movie_id: movieId
    else
      @perform 'unfollow'

  installPageChangeCallback: ->
    unless @installedPageChangeCallback
      @installedPageChangeCallback = true
$(document).on 'turbolinks:load', -> App.comments.followCurrentMovie()
