require 'test_helper'

class UserSignupTest < ActionDispatch::IntegrationTest
  test 'should successfully signup valid user' do
    get '/signup'
    assert_response :success
    assert_difference('User.count', 1) do
      post users_path, params: { user: { username: 'test user', email: 'test@exmaple.com',
        password: 'password', admin: false } }
      assert_response :redirect
    end
    follow_redirect!
    assert_response :success
    assert_match 'Search', response.body
  end

  test 'should not signup user with invalid username' do
    get '/signup'
    assert_response :success
    assert_no_difference('User.count') do
      post users_path, params: { user: { username: ' ', email: 'test@exmaple.com',
        password: 'password', admin: false } }
    end
    assert_match 'Sign Up', response.body
    assert_match 'errors', response.body
    assert_select 'div.alert'
    assert_select 'h4.alert-heading'
  end

  test 'should not signup user with invalid email' do
    get '/signup'
    assert_response :success
    assert_no_difference('User.count') do
      post users_path, params: { user: { username: ' test-user ', email: 'test@exmcom',
        password: 'password', admin: false } }
    end
    assert_match 'Sign Up', response.body
    assert_match 'errors', response.body
    assert_select 'div.alert'
    assert_select 'h4.alert-heading'
  end
end
