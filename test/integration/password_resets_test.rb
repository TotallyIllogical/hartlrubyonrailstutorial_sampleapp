require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest

  # Special function that automatically runs before every test
  def setup
    # Question: ??
    ActionMailer::Base.deliveries.clear
    # :admin -> test/fixtures/users.yml
    @user = users(:admin)
  end

  test 'password reset' do
    # Go to reset password page, app/views/password_resets/new.html.erb
    get new_password_reset_path
    # Check so that the correct template is loaded and are able to render
    assert_template 'password_resets/new'
    # Send reset password request with invalid email
    post password_resets_path, params: { password_reset: { email: '' } }
    # Check so a message is showing
    assert_not flash.empty?
    # Check so you are on the same page as before
    assert_template 'password_resets/new'
    # Send reset password request with valid email
    post password_resets_path, params: { password_reset: { email: @user.email } }
    # Make sure old reset digest doesn't match the new one
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    # Check so that deliveries size is one, aka check so that one message was delivered
    assert_equal 1, ActionMailer::Base.deliveries.size
    # Check so message are rendered
    assert_not flash.empty?
    # Check so that user is redirected
    assert_redirected_to root_url
    # Assign user
    user = assigns(:user)
    # Go to edit password with invalid email
    get edit_password_reset_path(user.reset_token, email: '')
    # Check so user is redirected to homepage
    assert_redirected_to root_url
    # Toggle user to inactive
    user.toggle!(:activated)
    # Go to edit password with valid email
    get edit_password_reset_path(user.reset_token, email: user.email)
    # Check so that user gets redirected to homepage
    assert_redirected_to root_url
    # Toggle user badk to active
    user.toggle!(:activated)
    # Go to edit password with wrong token
    get edit_password_reset_path('wrong token', email: user.email)
    # Check so user is redirected to homepage
    assert_redirected_to root_url
    # Go to edit password with correct data
    get edit_password_reset_path(user.reset_token, email: user.email)
    # Check so correct template is renderd
    assert_template 'password_resets/edit'
    # Check so that the input value matches user email
    assert_select 'input[name=email][type=hidden][value=?]', user.email
    # Update password data with invalid password
    patch password_reset_path(user.reset_token),  params: { email: user.email, user: { password: "invalid",
      password_confirmation: "password" } }
    # Check so a error message are shown
    assert_select 'div#error_explanation'
    # Update password data with empty password data
    patch password_reset_path(user.reset_token), params: { email: user.email, user: { password: '',
      password_confirmation: '' } }
    # Check so a error message are shown
    assert_select 'div#error_explanation'
    # Update password data with correct password data
    patch password_reset_path(user.reset_token), params: { email: user.email, user: { password: 'password',
      password_confirmation: 'password' } }
    # Check so that user gets logged in
    assert is_logged_in?
    # Check so a message are shown
    assert_not flash.empty?
    # Check so that the user gets redirected to it's profile page
    assert_redirected_to user
    # Check so that user reset_digest is nullified
    assert_nil user.reload.reset_digest
  end

  test 'expired token' do
    # Go to reset password page
    get new_password_reset_path
    # Send reset password request with valid email
    post password_resets_path, params: { password_reset: { email: @user.email } }
    # Assign user
    @user = assigns(:user)
    # Set time for reset request to passed due time 
    @user.update_attribute(:reset_sent_at, 3.hours.ago)
    # Go to edit password page with correct data
    patch password_reset_path(@user.reset_token), params: { email: @user.email, user: { password: 'password',
      password_confirmation: 'password' } }
    # Check so the respons is a redirect
    assert_response :redirect
    # Follow the redirect
    follow_redirect!
    # Check so that the word "expired" exists somewhere inside the body tag
    assert_match /expired/i, response.body
  end

end
