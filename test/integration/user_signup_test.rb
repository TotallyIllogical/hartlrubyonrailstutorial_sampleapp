require 'test_helper'

class UserSignupTest < ActionDispatch::IntegrationTest

  # Special function that automatically runs before every test
  def setup
    # :jaffagoauld -> test/fixtures/users.yml
    @user1 = users(:jaffagoauld1)
    ActionMailer::Base.deliveries.clear
  end

  test 'invalid signup information' do
    # Gets the signup page
    get signup_path
    # Check so that no user is created
    assert_no_difference 'User.count' do
      # Post an invalid user
      post users_path, params:{ user: {name: '', email: 'user@invalid', password: 'inv', password_confirmation:'alid'}}
    end
    # Check so that the correct template is used
    assert_template 'users/new'
    # Check that this shows up
    assert_select 'div#error_explanation'
    # Check that this shows up
    assert_select 'div.alert-danger'
  end

  test 'valid signup information before activation' do
    # Get signup page
    get signup_path
    # Check so that a new user is created (User.count increase by 1)
    assert_difference 'User.count', 1 do
      # Post a valid user
      post users_path, params: { user: { name: 'Valid User', email: 'user@valid.com', password: 'password',
        password_confirmation: 'password'
      } }
    end
    # Follow the redirect to show template
    follow_redirect!
    # Verify that the template is home
    assert_template 'static_pages/home'
    # Make shure that flash is not empty (showing the success message app/controllers/users_controller.rb)
    assert_not flash.empty?
    # Checks that the user is logged in,, test/test_helper.rb
    # assert is_logged_in?
  end

  test 'valid signup information after activation' do
    # Get signup page
    get signup_path
    # Check so that a new user is created (User.count increase by 1)
    assert_difference 'User.count', 1 do
      # Post a valid user
      post users_path, params: { user: { name: 'Valid User', email: 'user@valid.com', password: 'password',
        password_confirmation: 'password'
      } }
    end
    # Check so that deliveries size is one, aka check so that one message was delivered
    assert_equal 1, ActionMailer::Base.deliveries.size
    # Get the user
    user = assigns(:user)
    # Check so that user is not activated
    assert_not user.activated?
    # Check so that user is not logged in
    assert_not is_logged_in?
    # Get activation path with wrong token, type 'rails routes' in the console
    get edit_account_activation_path('invalid token', email: user.email)
    # Check so that user is not logged in
    assert_not is_logged_in?
    # Get activation path with wrong email
    get edit_account_activation_path(user.activation_token, email: 'invalid@email')
    # Check so that user is not logged in
    assert_not is_logged_in?
    # Get activation path with correct data
    get edit_account_activation_path(user.activation_token, email: user.email)
    # Check that the user is activated
    assert user.reload.activated?
    # Follow the redirect to show template
    follow_redirect!
    # Verify that the template is show
    assert_template 'users/show'
    # Checks that the user is logged in, test/test_helper.rb
    assert is_logged_in?
  end

end

