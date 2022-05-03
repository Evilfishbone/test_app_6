require 'test_helper'

class UserSignupTest < ActionDispatch::IntegrationTest
  test "get new user form sign up user" do
    get "/signup"
      assert_response :success
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { username: "testuser", email: "test@foobar.com",
                                         password: "password", admin: false } }
      assert_response :redirect
    end
    follow_redirect!
    assert_response :success
    assert_match User.last.username, response.body
  end
  
  test "get new user form and invalid sign up user" do
    get "/signup"
      assert_response :success
    assert_no_difference 'User.count' do
      post users_path, params: { user: { username: "", email: "test@abc.comc.om",
                                         password: "xx", admin: false } }
    end
    assert_match "The following errors prevented the", response.body
    assert_select "div.alert"
    assert_select "h4.alert-heading"
  end
end