require 'test_helper'

class UserMailerTest < ActionMailer::TestCase

  test "account_activation" do
    # Get a user
    user = users(:admin)
    # Set token
    user.activation_token = User.new_token
    # Set mail
    mail = UserMailer.account_activation(user)
    # Check the subject line matches what we have set
    assert_equal "Account activation", mail.subject
    # Check so that user email matches the one set as mail.to
    assert_equal [user.email], mail.to
    # Check so that the sender email matches the one we set
    assert_equal ["from@example.com"], mail.from
    # Check sit that cgi escape email matches the one encoded in the email template
    assert_match CGI.escape(user.email), mail.body.encoded
  end

  test "password_reset" do
    # Get a user
    user = users(:admin)
    # Set token
    user.reset_token = User.new_token
    # Set mail
    mail = UserMailer.password_reset(user)
    # Check the subject line matches what we have set
    assert_equal "Reset password", mail.subject
    # Check so that user email matches the one set as mail.to
    assert_equal [user.email], mail.to
    # Check so that the sender email matches the one we set
    assert_equal ["from@example.com"], mail.from
    # Check sit that cgi escape email matches the one encoded in the email template
    assert_match CGI.escape(user.email), mail.body.encoded
  end

end
