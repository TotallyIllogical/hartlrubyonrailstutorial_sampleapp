require 'test_helper'

class UserEditTest < ActionDispatch::IntegrationTest

  # Special function that automatically runs before every test
  def setup
    # :railsuser -> test/fixtures/users.yml
    @user = users(:railsuser)
  end

  test 'unsuccessful edit' do
    # Get edit user path
    get edit_user_path(@user)
    # Check so that correct template is used and is able to load
    assert_template 'users/edit'
    #  Question: What's patch? Why use it here and not anywhere else?
    patch user_path(@user), params: { user: { name: '', email: 'invalid@email', password: 'inv',
      password_confirmation: 'alid' } }
    # Check so that template is rendered again
    assert_template 'users/edit'
    # Check that this shows up
    assert_select 'div.alert-danger', 'The form contains 4 errors.'
  end

  test 'successful edit' do
    get edit_user_path(@user)
    assert_template 'users/edit'
    name = 'Valid User'
    email = 'valid@email.com'
    patch user_path(@user), params:{ user: { name: name, email: email, password: '',
      password_confirmation: '' } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end

end
