class PasswordResetsController < ApplicationController

  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    # Set user
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    # If user is found (not empty)
    if @user
      # create_reset_digest -> app/models/user.rb
      @user.create_reset_digest
      # send_password_reset_email -> app/models/user.rb
      @user.send_password_reset_email
      # Show message
      flash[:info] = "An email with password reset has been sent to #{@user.email}"
      # Redirect to home page
      redirect_to root_url
    else
      # Show message
      flash.now[:danger] = "Inputed email did not match a user"
      # Render page again
      render 'new'
    end
  end

  def edit
  end

  def update
    # Check if password field is empty
    if params[:user][:password].empty?
      # Show error message
      @user.errors.add(:password, "Password can't be empty")
      # Rerender edit page
      render 'edit'
    # Check if user password passes
    elsif @user.update_attribute(user_params)
      # Log in user
      log_in @user
      # Show message
      flash[:success] = "Your password has been reseted."
      # redirec to user profile
      redirect_to @user
    else
      # Rerender edit page
      render 'edit'
    end
  end

  private

    # Definges the parameters needed to create a user
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    # Get user data
    def get_user
      @user = User.find_by(email: params[:email])
    end

    # Check if user is valid
    def valid_user
      # If user is not valid redirect to home page
      unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end

    def check_expiration
      # If password expirdation date has passed, password_reset_expired? -> app/models/user.rb
      if @user.password_reset_expired?
        # Show message
        flash[:danger] = "The password reset link has expired"
        # Redirect to password reset form
        redirect_to new_password_reset_url
      end
    end

end
