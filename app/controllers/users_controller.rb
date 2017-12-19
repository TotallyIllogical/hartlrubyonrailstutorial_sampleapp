class UsersController < ApplicationController

  before_action :logged_in_user, only: [:index, :edit, :update]
  before_action :correct_user, only: [:edit, :update]
  # app/views/users/new.html.erb
  def new
    # Defines @user to be used in new template
    @user = User.new
  end

  # app/views/users/show.html.erb
  def show
    # Creates a user variable to be used in the show template
    @user = User.find(params[:id])
  end

  def create
    # Redefined the @user, now with the info filled in the form
    @user = User.new(user_params)
    # If user is savable (valid)
    if @user.save
      # Login the user
      log_in @user
      # Show a flash message
      flash[:success] = 'Welcome to the Sample App'
      # Redirect to the user page (show template)
      redirect_to @user
    # If user is not savable (invalid)
    else
      # Render new page again (new template)
      render 'new'
    end
  end

  def edit
    # Get the user
    @user = User.find(params[:id])
  end

  def update
    # Get the user
    @user = User.find(params[:id])
    # If user is updatable
    if @user.update_attributes(user_params)
      # Something
      flash[:success] = "Your profile has been updated"
      redirect_to @user
    else
      # Render the edit page again
      render 'edit'
    end
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  # Question: Why is private flooting by itself? Why no ending?
  private
    # Definges the parameters needed to create a user
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

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

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

end
