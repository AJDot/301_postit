class SessionsController < ApplicationController
  before_action :require_user, only: [:destroy]
  before_action :require_no_user, only: [:new]

  def new; end

  def create
    # ex: user.authenticate('password')
    # 1. get the user obj
    # 2. see if password matches
    # 3. if so, log in
    # 4. if not, error message

    user = User.find_by(username: params[:username])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:notice] = "Welcome, you've logged in."
      redirect_to root_path
    else
      flash[:error] = "There's something wrong with your username or password."
      redirect_to login_path
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "You've logged out!"
    redirect_to root_path
  end
end
