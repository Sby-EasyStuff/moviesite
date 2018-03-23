require 'test_helper'

class QueriesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @query = queries(:one)
  end


  test "should get show if logged in" do
    sign_in users(:one)
    get query_path(@query)
    assert_response :success
  end

  test "should not get show if not logged in" do
    get query_path(@query)
    assert_response :redirect
  end

  test "should get new if logged in" do
    sign_in users(:one)
    get new_query_path
    assert_response :success
  end

  test "should not get new if not logged in" do
    get new_query_path
    assert_response :redirect
  end
end
