require 'test_helper'

class MicropostTest < ActiveSupport::TestCase

  # Special function that automatically runs before every test
  def setup
    # :admin -> test/fixtures/users.yml
    @user = users(:admin)
    # Create a micropost
    @micropost = @user.microposts.build(content:'First post')
  end

  test 'should be valid' do
    # Check so that micropost is valid
    assert @micropost.valid?
  end

  test 'user id should be present' do
    # Nullifying user id
    @micropost.user_id = nil
    # Check so that micropost is not valid when user id is nullified
    assert_not @micropost.valid?
  end

  test 'content should not be empty' do
    # Set micropost content to an empty string
    @micropost.content = ''
    # Check so that micropost is not valid when content is empty
    assert_not @micropost.valid?
  end

  test 'content should not be longer than 140 characters' do
    # Change content to a 141 character long string
    @micropost.content = 'a' * 141
    # Check so that micropost is not valid when content is too long
    assert_not @micropost.valid?
  end

  test 'most recent post should show first' do
    # :micropost -> test/fixtures/microposts.yml
    assert_equal microposts(:micropostfive), Micropost.first
  end

end
