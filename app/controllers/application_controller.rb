class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  def hello
    render html: "Hello! This is the app called Sample App from Michael Hartl Runy on Rails Tutorial"
  end
end
