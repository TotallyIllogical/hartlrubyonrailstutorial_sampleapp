require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest

  # Special function that automatically runs before every test
  def setup
    # :jaffagoauld -> test/fixtures/users.yml
    @admin = users(:jaffagoauld1)
    @user = users(:jaffagoauld2)
    @nopost_user = users(:jaffagoauld3)
  end

  test 'micropost interface' do
    # Log in as user
    log_in_as(@user)
    #  Go to homepage
    get root_path
    # Check so that pagination shows up
    assert_select 'div.pagination'
    # Check so that this type of input is found on the page
    assert_select 'input[type="file"]'
    # Check so that the amount of micropost doesn't change when trying to post an empty post
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: '' } }
    end
    # Check so that the error message showes up
    assert_select 'div#error_explanation'
    # Add string to variable
    content  = "This post really ties the page together"
    # Add image to variable
    # Check so that the amount of micropost change when a correctly made post are made
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { content: content } }
    end
    picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
    # Check so that the amount of micropost change when a correctly made post with image are made
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { content: content, picture: picture } }
    end
    assert @user.microposts.first.picture?
    # Check so that the user are redirected to home
    assert_redirected_to root_url
    # Follow the redirect
    follow_redirect!
    # Check so that the post shows up
    assert_match content, response.body
    # Check so that the delete link shows
    assert_select 'a', text: 'Delete'
    # Get the first post from the first page
    first_micropost = @user.microposts.paginate(page: 1).first
    # Check so that the amount of posts are decreased by one
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
    # Get another user
    get users_path(@admin)
    # Check so that the second user doesn't see a delete link for the first users posts
    assert_select 'a', text: 'Delete', count: 0
  end

  test 'micropost sidebar count' do
    # Log in as user
    log_in_as(@user)
    # Go to homepage
    get root_path
    # Check so that this string shows up somewhere in the body-tag
    assert_match "#{@user.microposts.count} microposts", response.body
    # Log in as another user that has no posts
    log_in_as(@nopost_user)
    # Go to homepage
    get root_path
    # Check so that this string is found somewhere in the body-tag
    assert_match "0 microposts", response.body
    # Create a post for the user that didn't have one previously
    @nopost_user.microposts.create!(content: "My first post!")
    # Go to homepage
    get root_path
    # Check so that this string shows up somewhere in the body-tag
    assert_match "#{@nopost_user.microposts.count} micropost", response.body
  end

end
