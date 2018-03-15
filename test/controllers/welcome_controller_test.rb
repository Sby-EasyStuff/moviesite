require 'test_helper'

class WelcomeControllerTest < ActionDispatch::IntegrationTest
  test "Should get index" do
    get root_path
    assert_response :success
  end
end
