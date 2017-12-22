class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # Creates a simple html page
  def hello
    render html: "Hello! This is the app called Sample App from Michael Hartl Runy on Rails Tutorial"
  end

  # Makes so that the sessions helper is included for all controllers
  include SessionsHelper

  private

    # Make sure user is logged in
    def logged_in_user
      # logged_in? -> app/helpers/sessions_helper.rb
      # If not logged in
      unless logged_in?
        store_location
        # Show message
        flash[:danger] = 'Please log in'
        # Rediredct to login page
        redirect_to login_url
      end
    end

end
