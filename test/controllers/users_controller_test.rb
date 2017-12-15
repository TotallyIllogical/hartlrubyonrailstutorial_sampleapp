require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  # Checks if new template can be found
  test "should get new" do
    # Gets signup_path
    get signup_path
    # Checked so that the alert is 'success'
    assert_response :success
  end

end
