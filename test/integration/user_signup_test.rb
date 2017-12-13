require 'test_helper'

class UserSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  test 'invalid signup information' do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params:{ user: {name: '', email: 'user@invalid', password: 'inv', password_confirmation:'alid'}}
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert-danger'
  end

  test 'valid signup information' do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: {
        name: 'Valid User',
        email: 'user@valid.com',
        password: 'password',
        password_confirmation: 'password'
      } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
    assert is_logged_in?
  end

end

