require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  test 'layout_links' do
    # Fetches root_path
    get root_path
    # Check that right template is used
    assert_template 'static_pages/home'
    # Checks that the correct links are found on home page
    assert_select 'a[href=?]', root_path, count:2
    assert_select 'a[href=?]', help_path
    assert_select 'a[href=?]', about_path
    assert_select 'a[href=?]', contact_path
    assert_select 'a[href=?]', signup_path
    assert_select 'a[href=?]', login_path
    # Fetches contact page
    get contact_path
    # Checks so contact page title
    assert_select 'title',full_title('Contact')
  end
end
