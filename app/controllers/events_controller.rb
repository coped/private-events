class EventsController < ApplicationController
  def index
    @upcoming_events = Event.upcoming.paginate(page: params[:page], per_page: 8)
    @previous_events = Event.previous.paginate(page: params[:page], per_page: 8)
  end

  def new
    @event = current_user.created_events.build
  end

  def create
    @event = current_user.created_events.build(event_params)
    if @event.save
      flash[:success] = "Event created."
      redirect_to event_path(@event)
    else
      flash.now[:warning] = "An error occurred. Please try again."
      render 'events/new'
    end
  end

  def show
    @event = Event.find_by(id: params[:id])
    @all_invitees = User.where.not('username = ?', @event.creator.username).order(username: :asc)
    @invitation = @event.invitations.build
  end

  private

    def event_params
      params.require(:event).permit(:name, :description, :date, :location)
    end
end
