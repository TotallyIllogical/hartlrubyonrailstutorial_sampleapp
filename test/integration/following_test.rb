require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest

  # Special function that automatically runs before every test
  def setup
    # :admin -> test/fixtures/users.yml
    @admin = users(:admin)
    @user = users(:arthur)
    log_in_as(@admin)
  end

  test 'following page' do
    get following_user_path(@admin)
    assert_not @admin.following.empty?
    assert_match @admin.following.count.to_s, response.body
    @admin.following.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end

  test 'should follow a user in the standard way' do
    assert_difference '@admin.following.count', 1 do
      post relationships_path, params: {followed_id: @user.id}
    end
  end

  test 'should follow a user with Ajax' do
    assert_difference '@admin.following.count', 1 do
      post relationships_path, xhr: true, params: {followed_id: @user.id}
    end
  end

  test 'should unfollow a user the standard way' do
    @admin.follow(@user)
    relationship = @admin.active_relationships.find_by(followed_id: @user.id)
    assert_difference '@admin.following.count', -1 do
      delete relationship_path(relationship)
    end
  end

  test 'should unfollow a user with Ajax' do
    @admin.follow(@user)
    relationship = @admin.active_relationships.find_by(followed_id: @user.id)
    assert_difference '@admin.following.count', -1 do
      delete relationship_path(relationship), xhr: true
    end
  end

  test 'should show feed on homepage' do
    get root_path
    @admin.feed.paginate(page: 1).each do |micropost|
      assert_match CGI.escapeHTML(micropost.content), response.body
    end
  end

end
