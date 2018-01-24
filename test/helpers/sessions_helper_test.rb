require 'test_helper'

class SessionsHelperTest < ActionView::TestCase

  # Special function that automatically runs before every test
  def setup
    # :admin -> test/fixtures/users.yml
    @user1 = users(:admin)
    # app/helpers/sessions_helper.rbm
    remember(@user1)
  end

  test 'current_user returns right user when session is nil' do
    # Checks is the @user1 matches the current one, current_user -> app/helpers/sessions_helper.rb
    assert_equal @user1, current_user
    # Checks if user is logged in, test/test_helper.rb
    assert is_logged_in?
  end

  test 'current_user returns nil when remember digest is wrong' do
    @user1.update_attribute(:remember_digest, User.digest(User.new_token))
    # Check so that current_user is nil, current_user -> app/helpers/sessions_helper.rb
    assert_nil current_user
  end

end