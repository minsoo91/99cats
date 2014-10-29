class SessionsController < ApplicationController
  before_action :require_logged_in, except: [:new, :create]
  def new
    @user = User.new
    render :new
  end
  
  def create
    @user = User.find_by_credentials(
      params[:user][:user_name],
      params[:user][:password]
    )
    
    if @user.nil?
      redirect_to new_session_url
    else
      @user.reset_session_token!
      login!(@user)
      redirect_to cats_url
    end
  end
  
  def destroy
    user = current_user
    session[:session_token] = nil
    user.reset_session_token!
    current_user = nil
    redirect_to cats_url
  end
  
end
