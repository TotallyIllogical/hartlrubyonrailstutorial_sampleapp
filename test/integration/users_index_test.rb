require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  # Special function that automatically runs before every test
  def setup
    # :jaffagoauld -> test/fixtures/users.yml
    @admin_user = users(:jaffagoauld1)
    @simple_user = users(:jaffagoauld2)
  end

  test 'index include pagination' do
    # Log in as user
    log_in_as(@simple_user)
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

  test 'index page shows pagination and delete links for admin users' do
    # Log in as admin user
    log_in_as(@admin_user)
    # Go to the users list
    get users_path
    # Check so that the correct template is loaded and are rendering correct
    assert_template 'users/index'
    # Check so there are two element with the class 'pagination'
    assert_select 'div.pagination', count: 2
    # For each user on page 1
    User.paginate(page: 1).each do |user|
      # Check that there is a link to each users profile
      assert_select 'a[href=?]', user_path(user), text: user.name
      # If user is admin
      unless user == @admin_user
        # Check so that delete links shows
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end
  end

  test 'delete links should not show for non-admin users' do
    # Log in as a none-admin user
    log_in_as(@simple_user)
    # Go to users list
    get users_path
    # Check so that the correct template is used and that it can be loaded
    assert_template 'users/index'
    # Check so that no delete links shows up
    assert_select 'a', text: 'delete', count: 0
  end

end
