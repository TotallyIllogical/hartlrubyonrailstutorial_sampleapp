require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  # Special function that automatically runs before every test
  def setup
    # :railsuser -> test/fixtures/users.yml
    @user1 = users(:railsuser1)
    @user2 = users(:railsuser2)

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

end
