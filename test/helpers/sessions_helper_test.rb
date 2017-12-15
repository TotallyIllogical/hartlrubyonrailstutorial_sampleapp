require 'test_helper'

class SessionsHelperTest < ActionView::TestCase

  # Special function that automatically runs before every test
  def setup
    # :railsuser -> test/fixtures/users.yml
    @user = users(:railsuser)
    # app/helpers/sessions_helper.rbm
    remember(@user)
  end

  test 'current_user returns right user when session is nil' do
    # Checks is the @user matches the current one, current_user -> app/helpers/sessions_helper.rb
    assert_equal @user, current_user
    # Checks if user is logged in, test/test_helper.rb
    assert is_logged_in?
  end

  test 'current_user returns nil when remember digest is wrong' do
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    # Check so that current_user is nil, current_user -> app/helpers/sessions_helper.rb
    assert_nil current_user
  end

end