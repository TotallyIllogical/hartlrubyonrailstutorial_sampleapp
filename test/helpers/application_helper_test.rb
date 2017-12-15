require 'test_helper'

class ApplicationHelpTest < ActionView::TestCase

  # Tests title
  test 'full title helper' do
    # Function full_title can be found at app/helpers/application_helper.rb
    # Checks so that root_path title matches the text below
    assert_equal full_title, 'Ruby on Rails Tutorial Sample App'
    # Checks so that help page title matches the text below
    assert_equal full_title('Help'), 'Help | Ruby on Rails Tutorial Sample App'
    assert_equal full_title('About'), 'About | Ruby on Rails Tutorial Sample App'
    assert_equal full_title('Contact'), 'Contact | Ruby on Rails Tutorial Sample App'
    assert_equal full_title('Sign up'), 'Sign up | Ruby on Rails Tutorial Sample App'
    assert_equal full_title('Log in'), 'Log in | Ruby on Rails Tutorial Sample App'
  end

end