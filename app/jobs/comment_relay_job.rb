class CommentRelayJob < ApplicationJob
  def perform(comment)
    ActionCable.server.broadcast "movies:#{comment.movie_id}:comments",
      comment: CommentsController.render(partial: 'comments/comment', locals: { comment: comment })
  end
end
