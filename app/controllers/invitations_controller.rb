class InvitationsController < ApplicationController
  before_action :get_invitation, only: [:show, :update, :destroy]
  
  def create
    @invitation = Invitation.new(invite_params)
    if @invitation.save
      flash[:success] = "Invitation sent."
      redirect_to event_path(@invitation.invited_event)
    else
      flash[:warning] = "An error occurred. Please try again."
      redirect_to event_path(@invitation.invited_event)
    end
  end

  def show
    @event = @invitation.invited_event
  end

  def update
    if response_params == "true"
      @invitation.accept
      flash[:info] = "You're now attending this event!"
      redirect_to invitation_path(@invitation)
    else
      @invitation.decline
      flash[:info] = "You've declined this event. (you can still change your mind later)"
      redirect_to invitation_path(@invitation)
    end
  end

  def destroy
    @invitation.destroy
    flash[:info] = "Invitation deleted."
    redirect_to user_path(current_user)
  end

  private
    def get_invitation
      @invitation = Invitation.find_by(id: params[:id])
    end

    def invite_params
      params.require(:invitation).permit(:event_invitee_id, :invited_event_id)
    end

    def response_params
      params.require(:response)
    end
end
