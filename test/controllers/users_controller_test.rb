require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  # Special function that automatically runs before every test
  def setup
    # :jaffagoauld -> test/fixtures/users.yml
    @admin_user = users(:jaffagoauld1)
    @simple_user = users(:jaffagoauld2)

  end
  # Checks if new template can be found
  test "should get new" do
    # Gets signup_path
    get signup_path
    # Checked so that the alert is 'success'
    assert_response :success
  end

  test 'should redirect edit when logged in as wrong user' do
    # Log in as simple_user
    log_in_as(@simple_user)
    # Go to edit page for admin_user
    get edit_user_path(@admin_user)
    # Check so that there is no message
    assert flash.empty?
    # Check so user gets redirected to homepage
    assert_redirected_to root_url
  end

  test 'should redirect update when logged in as wrong user' do
    # Log in as simple_user
    log_in_as(@simple_user)
    # Update data for admin_user
    patch user_path(@admin_user), params: { user: { name: @admin_user.name, email: @admin_user.email } }
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
    # Log in as simple_user
    log_in_as(@simple_user)
    # Check that admin_user is admin
    assert @admin_user.admin?
    # Check so that simple_user is not an admin
    assert_not @simple_user.admin?
    # Update data for simple_user to become admin
    patch user_path(@simple_user), params: { user: { password: '123456', password_confirmation: '123456', admin: true } }
    # Check so that simple_user is not admin
    assert_not @simple_user.reload.admin?
  end

  test 'should redirect destroy when not logged in' do
    # Check so user count doesn't change
    assert_no_difference 'User.count' do
      # Remove simple_user
      delete user_path(@simple_user)
    end
    # Check so user gets redirected to homepage
    assert_redirected_to login_url
  end

  test 'should redirect destroy when logged in user is not admin' do
    # Log in as simple_user
    log_in_as(@simple_user)
    # Check so that user count doesn't change
    assert_no_difference 'User.count' do
      # Remove admin_user
      delete user_path(@admin_user)
    end
    # Check so that user gets redirected to homepage
    assert_redirected_to root_url
  end

  test 'admin should be able to destroy user' do
    # Log in as admin_user
    log_in_as(@admin_user)
    # Check so that user count loweres with 1
    assert_difference 'User.count', -1 do
      # Remove simple_user
      delete user_path(@simple_user)
    end
    # Check so that user gets redirected to users list
    assert_redirected_to users_url
  end

end
