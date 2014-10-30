class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  def current_user
    @current_user ||= User.find_by_session_token(session[:session_token])
  end
  helper_method :current_user
  
  def login!(user)
    session[:session_token] = user.session_token
  end
  
  def require_logged_in
    redirect_to new_session_url if current_user.nil?
  end
  
  def require_cat_owner
    # CatRentalRequest.find(params[:id]).cat.user == current_user
    cat = Cat.find(CatRentalRequest.find(params[:id]).cat_id)
    unless cat.user_id == current_user.id
      redirect_to cats_url
    end
  end
end
