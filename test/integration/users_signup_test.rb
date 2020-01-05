require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "user signup" do
    get root_path
    assert_select "a[href=?]", login_path
    get new_user_path
    assert_difference -> { User.count }, 1 do
      post users_path, params: { user: { username: "new_user" } }
    end
    new_user = User.last
    assert_redirected_to user_path(new_user)
    follow_redirect!
    assert_equal session[:user_id], new_user.id
    assert_select "a[href=?]", logout_path
  end
end
