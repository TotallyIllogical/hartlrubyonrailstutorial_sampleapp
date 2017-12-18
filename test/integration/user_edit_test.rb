require 'test_helper'

class UserEditTest < ActionDispatch::IntegrationTest

  # Special function that automatically runs before every test
  def setup
    # :railsuser -> test/fixtures/users.yml
    @user1 = users(:railsuser1)
  end

  test 'unsuccessful edit' do
    # What it says, log_in_as -> test/test_helper.rb
    log_in_as(@user1)
    # Get edit user path
    get edit_user_path(@user1)
    # Check so that correct template is used and is able to load
    assert_template 'users/edit'
    # Question: What's the difference between post, patch and put?? Why is it used here and not anywhere else?
    patch user_path(@user1), params: { user: { name: '', email: 'invalid@email', password: 'inv',
      password_confirmation: 'alid' } }
    # Check so that template is rendered again
    assert_template 'users/edit'
    # Check that this shows up
    assert_select 'div.alert-danger', 'The form contains 4 errors.'
  end

  test 'successful edit' do
    # What it says, log_in_as -> test/test_helper.rb
    log_in_as(@user1)
    # Get edit user path
    get edit_user_path(@user1)
    # Check so that correct template is used and is able to load
    assert_template 'users/edit'
    # Set variable 'name'
    name = 'Valid User'
    # Set variable 'email'
    email = 'valid@email.com'
    # Question: What's the difference between post, patch and put? Why is it used here and not anywhere else?
    patch user_path(@user1), params:{ user: { name: name, email: email, password: '',
      password_confirmation: '' } }
    # Check so that flash is not empty
    assert_not flash.empty?
    # Check so you are redirected
    assert_redirected_to @user1
    # Reload user
    @user1.reload
    # Check so name match
    assert_equal name, @user1.name
    # Check so htat email match
    assert_equal email, @user1.email
  end

end
