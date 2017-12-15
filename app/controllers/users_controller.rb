class UsersController < ApplicationController

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

  # Question: Why is private flooting by itself? Why no ending?
  private
    # Definges the parameters needed to create a user
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

end
