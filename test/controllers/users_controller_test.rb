require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  # Special function that automatically runs before every test
  def setup
    # :jaffagoauld -> test/fixtures/users.yml
    @user1 = users(:jaffagoauld1)
    @user2 = users(:jaffagoauld2)

  end
  # Checks if new template can be found
  test "should get new" do
    # Gets signup_path
    get signup_path
    # Checked so that the alert is 'success'
    assert_response :success
  end

  test 'should redirect edit when logged in as wrong user' do
    log_in_as(@user2)
    get edit_user_path(@user1)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test 'should redirect update when logged in as wrong user' do
    log_in_as(@user2)
    patch user_path(@user1), params: { user: { name: @user1.name, email: @user1.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test 'should redirect to index when not logged in' do
    get users_path
    assert_redirected_to login_url
  end

  test 'should not allow the admin attribute to be edited via the web' do
    log_in_as(@user2)
    assert @user1.admin?
    assert_not @user2.admin?
    patch user_path(@user2), params: { user: { password: '123456', password_confirmation: '123456', admin: true } }
    assert_not @user2.reload.admin?
  end

  test 'should redirect destroy when not logged in' do
    assert_no_difference 'User.count' do
      delete user_path(@user2)
    end
    assert_redirected_to login_url
  end

  test 'should redirect destroy when logged in user is not admin' do
    log_in_as(@user2)
    assert_no_difference 'User.count' do
      delete user_path(@user1)
    end
    assert_redirected_to root_url
  end

  test 'admin should be able to destroy user' do
    log_in_as(@user1)
    assert_difference 'User.count', -1 do
      delete user_path(@user2)
    end
    assert_redirected_to users_url
  end

end
