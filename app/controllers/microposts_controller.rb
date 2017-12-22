class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def create
    # Get current user's microposts
    @micropost = current_user.microposts.build(micropost_params)
    # If microposts are saveable
    if @micropost.save
      # Show message
      flash[:success] = "Micropost created"
      # Redirect to root
      redirect_to root_url
    else
      # Empty array
      @feed_items = []
      # Render template again
      render 'static_pages/home'
    end
  end

  def destroy
    # Delete microposts
    @micropost.destroy
    # Show message
    flash[:success] = "Micropost deleted"
    # Redirect to previouse url, if that's not possible redirects homepage
    redirect_back(fallback_location: root_url)
  end

  private
    def micropost_params
      params.require(:micropost).permit(:content, :picture)
    end

    def correct_user
      # Get micropost for current user
      @micropost = current_user.microposts.find_by(id: params[:id])
      # Go to homepage if micropost are nil
      redirect_to root_url if @micropost.nil?
    end

end
