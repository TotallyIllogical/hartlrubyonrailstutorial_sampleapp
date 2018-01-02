require 'test_helper'

class UserTest < ActiveSupport::TestCase

  # Special function that automatically runs before every test
  def setup
    # Creates a example user to use in the tests
    @clean = User.new(name:'Example User', email:'user@example.com',
      password: 'foobar', password_confirmation: 'foobar')
    @admin = users(:jaffagoauld1)
    @user = users(:jaffagoauld2)
    @other = users(:jaffagoauld4)
  end

  test 'should be valid' do
    # Checks if the the example user is valid
    assert @clean.valid?
  end

  test 'name should be present' do
    # Change content of user.name to a blank string
    @clean.name = '  '
    # Checks so that the user is not valid
    assert_not @clean.valid?
  end

  test 'email should be present' do
    # Change content of user.email to a blank string
    @clean.email = '  '
    # Checks so that the user is not valid
    assert_not @clean.valid?
  end

  test 'name should not be too long' do
    # Change user.name to a 51 character long string
    @clean.name = 'a' * 51
    # Checks so that the user is not valid
    assert_not @clean.valid?
  end

  test 'email should not be too long' do
    # Change user.email to a 244 character long string
    @clean.email = 'a' * 244 +'@example.com'
    # Checks so that the user is not valid
    assert_not @clean.valid?
  end

  test 'email validation should accept valid addresses' do
    # Array of examples of valid emails
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+wonderland@bas.cn]
    # Loop the array
    valid_addresses.each do |valid_address|
      # Changes user.email to on of the addresses in array
      @clean.email = valid_address
      # Checks so that the user is valid
      assert @clean.valid?,"#{valid_address.inspect} should be valid"
    end
  end

  test 'email validation should reject invalid addresses' do
    # Array of examples of invalid emails
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
    # Loop the array
    invalid_addresses.each do |invalid_address|
      # Changes user.email to on of the addresses in array
      @clean.email = invalid_address
      # Checks so that the user is not valid
      assert_not @clean.valid?,"#{invalid_address.inspect} should be invalid"
    end
  end

  test 'email address should be unique' do
    # Duplicates example user
    duplicate_user = @clean.dup
    # Changes the user email to uppercase
    duplicate_user.email = @clean.email.upcase
    # Save user
    @clean.save
    # Checks so that the duplicate user is not valid
    assert_not duplicate_user.valid?
  end

  test 'email should be saved as lowercase' do
    # Create a mix-cases email
    mixed_case_email = "Foo@ExamPLe.Com"
    # Change use email to the mix-cases email
    @clean.email = mixed_case_email
    # Save user
    @clean.save
    # Checks so that the the email is lowercase
    assert_equal mixed_case_email.downcase, @clean.reload.email
  end

  test 'password should be present (nonblank)' do
    # Changes password and password confirmation to a 6 character (minimum) long blank string
    @clean.password = @clean.password_confirmation = '  ' * 6
    # Checks so that the user is not valid
    assert_not @clean.valid?
  end

  test 'password should have a minimum length' do
    # Changes password and password confirmation to a 5 character long string
    @clean.password = @clean.password_confirmation = 'a' * 5
    # Checks so that the user is not valid
    assert_not @clean.valid?
  end

  test 'authenticated? should return false for a user with nil digest' do
    # authenticated? -> app/models/user.rb
    assert_not @clean.authenticated?(:remember, '')
    assert_not @clean.authenticated?(:activation, '')
  end

  test 'associated post should be removed when user is removed' do
    @clean.save
    @clean.microposts.create!(content: 'Hello world!')
    assert_difference 'Micropost.count', -1 do
      @clean.destroy
    end
  end

  test 'should follow and unfollow user' do
    assert_not @admin.following?(@clean)
    @admin.follow(@clean)
    assert @admin.following?(@clean)
    assert @clean.followers.include?(@admin)
    @admin.unfollow(@clean)
    assert_not @admin.following?(@clean)
  end

  test 'feed should have the right posts' do
    @user.microposts.each do |post_following|
      assert @admin.feed.include?(post_following)
    end
    @admin.microposts.each do |post_self|
      assert @admin.feed.include?(post_self)
    end
    @other.microposts.each do |post_unfollowed|
      assert_not @admin.feed.include?(post_unfollowed)
    end
  end

end
