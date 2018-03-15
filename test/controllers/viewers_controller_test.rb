require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "should get index" do
    get viewers_path
    assert_response :success
  end

  test "should get show if logged" do
    sign_in users(:one)
    get viewer_path id: users(:one)
    assert_response :success
  end

  test "should not get show if not logged" do
    get viewer_path id: users(:one)
    assert_response :redirect
  end

  test "should get edit if logged and same" do
    sign_in users(:one)
    get edit_viewer_path id: users(:one)
    assert_response :success
  end

  test "should not get edit if not same" do
    sign_in users(:two)
    get edit_viewer_path id: users(:one)
    assert_response :redirect
  end

  test "should not get edit if not logged" do
    get edit_viewer_path id: users(:one)
    assert_response :redirect
  end

end
