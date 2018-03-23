class MoviesController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :set_movie, only: [:show, :edit, :update]

  # GET /movies
  # GET /movies.json
  def index
    movie = params[:movie]
    if movie.blank?
      @movies = Movie.all.reverse
    else
      @movies = Movie.all
      @movies = Movie.where("lower(title) LIKE ?", "%#{movie.downcase}%")
    end
    @queries = Query.all
  end

  # GET /movies/1
  # GET /movies/1.json
  def show
    @movie = Movie.find_by_id(params[:id])
  end

  # POST /movies
  # POST /movies.json
  def create
    @movie = Movie.new(movie_params)

    respond_to do |format|
      if @movie.save
        format.html { redirect_to @movie, notice: 'Movie was successfully created.' }
        format.json { render :show, status: :created, location: @movie }
      else
        format.html { render :new }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movie
      @movie = Movie.find(params[:id])
      redirect_to movies_path, alert: 'Il film non è stato trovato' unless @movie
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def movie_params
      params.require(:movie).permit(:api_id, :title, :vote_average, :release_date, :overview, :url, :poster_path)
    end
end
