class SessionsController < ApplicationController
  before_action :user_logged_in?, except: [:destroy]

  def new
    render :new
  end

  def create
    login_user!
  end

  def destroy
    @user = current_user

    if @user
      @user.reset_session_token!
      session[:session_token] = nil
      redirect_to cats_url
    end
  end
end
