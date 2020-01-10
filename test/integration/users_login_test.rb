require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:example)
  end
  
  test "user login and logout" do
    get root_path
    assert_select "a[href=?]", login_path
    get login_path
    post login_path, params: { login: { username: "example_user" } }
    assert_redirected_to user_path(@user)
    follow_redirect!
    assert_equal session[:user_id], @user.id
    get root_path
    assert_select "a[href=?]", logout_path
    # Followed by logout
    delete logout_path
    assert_redirected_to root_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_nil session[:user_id]
  end
end
