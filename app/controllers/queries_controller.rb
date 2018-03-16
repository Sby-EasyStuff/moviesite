class QueriesController < ApplicationController
  include QueriesHelper
  before_action :authenticate_user!

  def index
    @queries = Query.all

  end

  def show
    @query = Query.find_by_id(params[:id])
    if @query.blank?
      redirect_to queries_path, alert: "Query non trovata"
    end
    @movies = Movie.where("api_id IN (?)", @query.movies)
    last_queries
  end

  def new
    @query = Query.new
    last_movie
  end

  def create
    @query = Query.new(query_params)
    query_in_db = Query.where("lower(query) = ?", @query.query.downcase).first
    if !query_in_db.blank?
      redirect_to query_in_db, notice: 'Query già presente'
    else
      # Make query to api => set of movie
      @query = search_query(@query)
      @query.query.downcase!
      if !@query.errors.any? && @query.save
        redirect_to @query, notice: 'Una nuova query è stata aggiunta al database'
      else
        last_movie
        render :new
      end
    end
  end

  private

  def query_params
    params.require(:query).permit(:query)
  end

  def last_movie
    @movie = Movie.last(30).reverse
    last_queries
  end

  def last_queries
      @queries = Query.last(50).reverse
  end

end
