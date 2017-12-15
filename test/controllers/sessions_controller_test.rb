require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest

  # Checks if new page exists
  test "should get new" do
    # Get login path
    get login_path
    # Checks that it exists
    assert_response :success
  end

end
