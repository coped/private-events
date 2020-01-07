require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:example)
  end
  
  test "should get new" do
    get new_user_path
    assert_response :success
  end

  test "should get show" do
    get user_path(@user)
    assert_response :success
    assert_match @user.username, response.body
  end
end
