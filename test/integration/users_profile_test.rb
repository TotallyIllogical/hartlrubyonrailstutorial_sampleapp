require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest

  include ApplicationHelper

  # Special function that automatically runs before every test
  def setup
    # :jaffagoauld -> test/fixtures/users.yml
    @admin = users(:jaffagoauld1)
    @user = users(:jaffagoauld2)
  end

  test 'profile display' do
    # Get a user
    get user_path(@user)
    # Check so right template user
    assert_template 'users/show'
    # Check so that the title is matches the user nane
    assert_select 'title', full_title(@user.name)
    # Check so that the h1-tag has the user name
    assert_select 'h1', text: @user.name
    # Check so that the h1-tag has the gravatar image
    assert_select 'h1>img.gravatar'
    # Check so that the mictopost count is found in the body-tag, to_s -> turn into string
    assert_match @user.microposts.count.to_s, response.body
    # Check so that the h3-tag has matching text
    assert_select 'h3', text: 'Posts (' + @user.microposts.count.to_s + ')'
    # Check so that pagination exist on the page
    assert_select 'div.pagination'
    # Get the microposts for first page
    @user.microposts.paginate(page: 1).each do |micropost|
      # Check so the posts are found
      assert_match micropost.content, response.body
    end
  end

end
