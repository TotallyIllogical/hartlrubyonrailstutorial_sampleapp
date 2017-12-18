require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest  # Special function that automatically runs before every test

  # Special function that automatically runs before every test
  def setup
    # :railsuser -> test/fixtures/users.yml
    @user = users(:railsuser)
  end

  test 'login with invalid information' do
    # Get login page
    get login_path
    # Check so the right template is used
    assert_template 'sessions/new'
    # Test post with invalid data
    post login_path, params: { session: { email: '', password: ''} }
    # Verfy that page hasn't changed
    assert_template 'sessions/new'
    # Verify that a error message are shown
    assert_not flash.empty?
    # Go to home page
    get root_path
    # Verify that the error message aren't shown
    assert flash.empty?
  end

  test 'login with valid information' do
    # Get login page
    get login_path
    # Test post with valid data (login user)
    post login_path, params: { session: { email: @user.email, password: 'password'} }
    # Verify that a valid login leads to a redirect to user page
    assert_redirected_to @user
    # Follow the redirect
    follow_redirect!
    # Check so that the correct template is used
    assert_template 'users/show'
    # Check so that the login link doesn't show up after user has logged in
    assert_select "a[href=?]", login_path, count: 0
    # Check so that the logout link shows up
    assert_select "a[href=?]", logout_path
    # Check so that a link to the user page exists
    assert_select "a[href=?]", user_path(@user)
  end

  test "login with valid information followed by logout" do
    # Go to login page
    get login_path
    # Test post with valid data (login user)
    post login_path, params: { session: { email: @user.email, password: 'password' } }
    # Check so that the user is logged in, test/test_helper.rb
    assert is_logged_in?
    # Check so user gets redirected to user page (show template)
    assert_redirected_to @user
    # Follow the redirect
    follow_redirect!
    # Check so that the correct template is used
    assert_template 'users/show'
    # Check so that the login link doesn't show up after user has logged in
    assert_select "a[href=?]", login_path, count: 0
    # Check so that the logout link shows up
    assert_select "a[href=?]", logout_path
    # Check so that a link to the user page exists
    assert_select "a[href=?]", user_path(@user)
    # Go to logout path
    delete logout_path
    # Check so user is not logged in after loggin out, test/test_helper.rb
    assert_not is_logged_in?
    # Check so that user is redirected to home page
    assert_redirected_to root_url
    # Question: Why two times?
    delete logout_path
    # Follow the redirect
    follow_redirect!
    # Check so that the login link show up again
    assert_select "a[href=?]", login_path
    # Check so that the logout link doesn't show up after user has logged out
    assert_select "a[href=?]", logout_path, count: 0
    # Check so that the user link doesn't show up after user has logged out
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  test 'login with remembering' do
    # Log in user with remember me active (simulate checkbox being checked), log_in_as() -> test/test_helper.rb
    log_in_as(@user, remember_me: '1')
    # Check so that cookies remember_me and the remember_me assigned to the user matches
    assert_equal cookies['remember_token'], assigns(:user).remember_token
    # Check so that cookies remember_me is not empty
    assert_not_empty cookies['remember_token']
  end

  test 'login without remebering' do
    #log_in_as() -> test/test_helper.rb
    # Set remember me to true
    log_in_as(@user, remember_me: '1')
    # Set remember me to false
    log_in_as(@user, remember_me: '0')
    # Check so that remember me is empty
    assert_empty cookies['remember_token']
  end

end
