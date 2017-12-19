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

  test 'shoudl redirect to index when not logged in' do
    get users_path
    assert_redirected_to login_url
  end

end
