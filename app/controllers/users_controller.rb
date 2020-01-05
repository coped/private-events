class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in(@user)
      flash[:success] = "#{@user.username} created!"
      redirect_to user_path(@user)
    else
      flash.now[:warning] = "An error occurred. Please try again."
      render "users/new"
    end
  end

  def show
    @user = User.find_by(id: params[:id])
  end

  private 

    def user_params
      params.require(:user).permit(:username)
    end
end
