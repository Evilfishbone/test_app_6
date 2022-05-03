require 'test_helper'

class CreateArticleTest < ActionDispatch::IntegrationTest
  
  setup do
    @user = User.create(username: "test", email: "test@foobar.com",
                        password: "Password", admin: false)
    sign_in_as(@user)
  end
  
  test "get new article form and create article" do
    get "/articles/new"
    assert_response :success
    assert_difference 'Article.count', 1 do
      post articles_path, params: { article: { title: "test article", description: "test description", user_id: @user.id } }
      assert_response :redirect
    end
    follow_redirect!
    assert_response :success
    assert_match Article.last.title, response.body
    assert_match @user.username, response.body
  end
  
  test "get new article form and reject invalid article submission" do
    get "/articles/new"
    assert_response :success
    assert_no_difference 'Category.count' do
      post articles_path, params: { article: { title: "" , description: "", user_id: ""} }
    end
    assert_match "The following errors prevented the", response.body
    assert_select "div.alert"
    assert_select "h4.alert-heading"
  end
end