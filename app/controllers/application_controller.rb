class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id] # memoization
  end

  def logged_in?
    !!current_user
  end

  def require_user
    if !logged_in?
      flash[:error] = "Must be logged in to do that."
      redirect_to root_path
    end
  end

  def require_no_user
    if logged_in?
      flash[:error] = "Can't be logged in to do that."
      redirect_to root_path
    end
  end

  def require_owner(user)
    if current_user != user
      flash[:error] = "Must be the owner to do that."
      redirect_to root_path
    end
  end
end
