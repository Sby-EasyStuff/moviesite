require 'test_helper'

class MoviesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @movie = movies(:one)
  end

  test "should get index" do
    get movies_path
    assert_response :success
  end

  test "should create movie" do
    sign_in users(:one)
    assert_difference('Movie.count') do
      post movies_url, params: { movie: {api_id: 15, title: 'Title', vote_average: 1.8, release_date: 2017-11-05, overview: 'Overvie', url: 'URL', poster_path: 'Poster_Path' } }
    end

    assert_redirected_to movie_url(Movie.last)
  end

  test "should not create movie if logged out" do
    assert_no_difference('Movie.count') do
      post movies_url, params: { movie: {api_id: 15, title: 'Title', vote_average: 1.8, release_date: 2017-11-05, overview: 'Overvie', url: 'URL', poster_path: 'Poster_Path' } }
    end

    assert_redirected_to new_user_session_path
  end


  test "should show movie if logged in" do
    sign_in users(:one)
    get movie_path(@movie)
    assert_response :success
  end

  test "should not show movie if not logged" do
    get movie_path(@movie)
    assert_response :redirect
  end

end
