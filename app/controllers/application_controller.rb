class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # Creates a simple html page
  def hello
    render html: "Hello! This is the app called Sample App from Michael Hartl Runy on Rails Tutorial"
  end

  # Makes so that the sessions helper is included for all controllers
  include SessionsHelper

end
