require 'test_helper'

class CreateNewArticleTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create(username: 'johndoe', email: 'jd@example.com', password: 'password', admin: false)

    sign_in_as(@user)
  end

  test 'should successfully create valid article' do
    get '/articles/new'
    assert_response :success
    assert_difference('Article.count', 1) do
      post articles_path, params: { article: { title: 'test title', description: 'test description' } }
      assert_response :redirect
    end
    follow_redirect!
    assert_response :success
    assert_match 'Created', response.body
  end

  test 'should not create invalid article' do
    get '/articles/new'
    assert_response :success
    assert_no_difference('Article.count') do
      post articles_path, params: { article: { title: 'tt', description: 'test description' } }
    end
    assert_match 'Create New Article', response.body
    assert_match 'errors', response.body
    assert_select 'div.alert'
    assert_select 'h4.alert-heading'
  end
end
