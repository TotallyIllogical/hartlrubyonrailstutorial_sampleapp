require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  # Special function that automatically runs before every test
  def setup
    # :jaffagoauld -> test/fixtures/users.yml
    @user1 = users(:jaffagoauld1)
  end

  test 'index include pagination' do
    # Log in as user
    log_in_as(@user1)
    # Go to users index page
    get users_path
    # Check so that the correct template is used and that it can be loaded
    assert_template 'users/index'
    # Check so that there are two pagination elements
    assert_select 'div.pagination', count: 2
    # For each user on page 1 check so that there is a link for that user's page and that it contains the user's name
    User.paginate(page: 1).each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
    end
  end

end
