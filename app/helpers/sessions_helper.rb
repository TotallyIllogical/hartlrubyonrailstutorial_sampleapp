module SessionsHelper

  # Log in user
  def log_in(user)
    session[:user_id] = user.id
  end

  # Returns the current user if ther is one
  def current_user
    # Check if there is a user id in session and assigns it to the variable named user_id
    if (user_id = session[:user_id])
      # Load user by user id
      @current_user ||= User.find_by(id: user_id) # @current_user = @current_user || User.find_by(id: session[:user_id])
    # Check if there is a user id in cookies and assigns it to the variable named user_id
    elsif (user_id = cookies.signed[:user_id])
      # Load user by user id
      user = User.find_by(id: user_id)
      # Check if user exist, that it's valid and that the remember me is set
      # authenticated? -> app/models/user.rb
      if user && user.authenticated?(cookies[:remember_token])
        # login user, see above
        log_in user
        # Sets user to current_user
        @current_user = user
      end
    end
  end

  def current_user?(user)
    user == current_user
  end

  def logged_in?
    # Checks so that current user is not empty
    !current_user.nil?
  end

  def forget(user)
    # Forgets user
    user.forget
    # Delete user id from cookie
    cookies.delete(:user_id)
    # Delete remember from cookie
    cookies.delete(:remember_token)
  end

  def log_out
    # Forget helper above
    forget(current_user)
    # Delete user id form session
    session.delete(:user_id)
    # Empy out current user
    @current_user = nil
  end

  def remember(user)
    # Remember user
    user.remember
    # Sets user id to cookies id
    cookies.permanent.signed[:user_id] = user.id
    # Sets remember to cookies remember
    cookies.permanent[:remember_token] = user.remember_token
  end

  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

end
