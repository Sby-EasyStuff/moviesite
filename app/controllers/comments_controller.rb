class CommentsController < ApplicationController
  before_action :set_movie

  def create
    @comment = Comment.create! body: params[:comment][:body], movie: @movie, user: current_user
  end

  private
    def set_movie
      @movie = Movie.find(params[:movie_id])
    end
end
