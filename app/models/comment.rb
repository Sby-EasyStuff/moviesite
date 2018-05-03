class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :movie

  after_commit { CommentRelayJob.perform_later(self) }
end
