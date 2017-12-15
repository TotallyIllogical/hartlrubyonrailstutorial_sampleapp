require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  # Special function that automatically runs before every test
  def setup
    # Added an instance varible for the part of the title that are repeated
    @base_title = "Ruby on Rails Tutorial Sample App"
  end

  # Testing that root_url is found
  test "should get root" do
    get root_url
    assert_response :success
  end

  # Testing if home page is found and has correct title
  test "should get home" do
    # Fetch root_path
    get root_path
    # Check that path is found
    assert_response :success
    # Check if page has correct title
    assert_select "title", "#{@base_title}"
  end

  # Testing if help page is found and has correct title
  test "should get help" do
    # Paths are generated automatically, type "rails routes" to see what are available
    get help_path
    assert_response :success
    assert_select "title", "Help | #{@base_title}"
  end

  # Testing if about page is found and has correct title
  test "should get about" do
    get about_path
    assert_response :success
    assert_select "title", "About | #{@base_title}"
  end

  # Testing if contact page is found and has correct title
  test "should get contact" do
    get contact_path
    assert_response :success
    assert_select "title", "Contact | #{@base_title}"
  end

end
