class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :used_logged_in?, :validate_user

  def current_user
    @user = User.find_by(session_token: session[:session_token])
  end

  def login_user!
    @info = params[:user]
    @user = User.find_by_credentials(@info[:username], @info[:password])
    if @user
      @user.reset_session_token!
      session[:session_token] = @user.session_token
      redirect_to cats_url
    else
      flash.now[:errors] = "Invalid username or password"
      render :new
    end
  end

  def user_logged_in?
    if !!current_user
      redirect_to cats_url
    end
  end

  def validate_user
    !(current_user.nil? ||
      current_user.cats.none? { |cat| cat.id == params[:id].to_i })
  end
end
