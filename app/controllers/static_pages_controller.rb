class StaticPagesController < ApplicationController

  # Controllers needs to be defined in order for everything to work
  def home
    if logged_in?
      # Get micropost
      @micropost  = current_user.microposts.build
      # Get feed and paginate it, feed -> app/models/user.rb
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def help
  end

  def about
  end

  def contact
  end

  def login
  end

end
