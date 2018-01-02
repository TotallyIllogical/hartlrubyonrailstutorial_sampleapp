require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  # Special function that automatically runs before every test
  def setup
    # :jaffagoauld -> test/fixtures/users.yml
    @admin = users(:jaffagoauld1)
    @user = users(:jaffagoauld2)

  end
  # Checks if new template can be found
  test "should get new" do
    # Gets signup_path
    get signup_path
    # Checked so that the alert is 'success'
    assert_response :success
  end

  test 'should redirect edit when logged in as wrong user' do
    # Log in as user
    log_in_as(@user)
    # Go to edit page for admin
    get edit_user_path(@admin)
    # Check so that there is no message
    assert flash.empty?
    # Check so user gets redirected to homepage
    assert_redirected_to root_url
  end

  test 'should redirect update when logged in as wrong user' do
    # Log in as user
    log_in_as(@user)
    # Update data for admin
    patch user_path(@admin), params: { user: { name: @admin.name, email: @admin.email } }
    # Check so no message are shown
    assert flash.empty?
    # Check so that user gets redirected to home page
    assert_redirected_to root_url
  end

  test 'should redirect to index when not logged in' do
    # Go to list of users when not logged in
    get users_path
    # Check so user gets redirected to home page
    assert_redirected_to login_url
  end

  test 'should not allow the admin attribute to be edited via the web' do
    # Log in as user
    log_in_as(@user)
    # Check that admin is admin
    assert @admin.admin?
    # Check so that user is not an admin
    assert_not @user.admin?
    # Update data for user to become admin
    patch user_path(@user), params: { user: { password: '123456', password_confirmation: '123456', admin: true } }
    # Check so that user is not admin
    assert_not @user.reload.admin?
  end

  test 'should redirect destroy when not logged in' do
    # Check so user count doesn't change
    assert_no_difference 'User.count' do
      # Remove user
      delete user_path(@user)
    end
    # Check so user gets redirected to homepage
    assert_redirected_to login_url
  end

  test 'should redirect destroy when logged in user is not admin' do
    # Log in as user
    log_in_as(@user)
    # Check so that user count doesn't change
    assert_no_difference 'User.count' do
      # Remove admin
      delete user_path(@admin)
    end
    # Check so that user gets redirected to homepage
    assert_redirected_to root_url
  end

  test 'admin should be able to destroy user' do
    # Log in as admin
    log_in_as(@admin)
    # Check so that user count loweres with 1
    assert_difference 'User.count', -1 do
      # Remove user
      delete user_path(@user)
    end
    # Check so that user gets redirected to users list
    assert_redirected_to users_url
  end

  test "should redirect following when not logged in" do
    get following_user_path(@admin)
    assert_redirected_to login_url
  end

  test 'should redirect followers when not logged in' do
    get followers_user_path(@admin)
    assert_redirected_to login_url
  end

end
