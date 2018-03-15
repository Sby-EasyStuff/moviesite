require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "Should not save another user with same email" do
    user = User.new
    user.email = "one@example.com"
    user.password="password"
    assert_raises("ActiveRecord::RecordInvalid") { user.save! }
  end
end
