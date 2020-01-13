class UsersController < ApplicationController
  before_action :redirect_if_logged_in, only: [:new]
  
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
    @upcoming_events = @user.upcoming_events
    @previous_events = @user.previous_events
    @invitations = @user.invitations.paginate(page: params[:page], per_page: 5).order(created_at: :desc)
  end

  private

    def redirect_if_logged_in
      redirect_to user_path(current_user) if logged_in?
    end

    def user_params
      params.require(:user).permit(:username)
    end
end
