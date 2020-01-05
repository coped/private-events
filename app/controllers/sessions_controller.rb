class SessionsController < ApplicationController
  def new
  end

  def create
    if @user = User.find_by(username: login_params[:username])
      log_in(@user)
      redirect_to user_path(@user)
    else
      flash.now[:warning] = "Username not found. Please try again."
      render "sessions/new"
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

  private

    def login_params
      params.require(:login).permit(:username)
    end
end
