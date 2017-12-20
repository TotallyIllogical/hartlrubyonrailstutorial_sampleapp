class AccountActivationsController < ApplicationController

  def edit
    # Get user model based on email
    user = User.find_by(email: params[:email])
    # If user is found, is not activated and authenticated
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      # Activate user, activate ->  -> app/models/user.rb
      user.activate
      # Log in the user
      log_in user
      # Show message
      flash[:success] = "Your account has been activated"
      # Redirect to user's profile
      redirect_to user
    else
      # Show message
      flash[:danger] = "The activation link was invalid"
      # Redirect to home page
      redirect_to root_url
    end
  end

end
