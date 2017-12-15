require 'test_helper'

class UserSignupTest < ActionDispatch::IntegrationTest

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

  test 'valid signup information' do
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
    # Verify that the template is show
    assert_template 'users/show'
    # Make shure that flash is not empty (showing the success message app/controllers/users_controller.rb)
    assert_not flash.empty?
    # Checks that the user is logged in,, test/test_helper.rb
    assert is_logged_in?
  end

end

