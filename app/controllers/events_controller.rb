class EventsController < ApplicationController
  def index
    @upcoming_events = Event.upcoming
    @previous_events = Event.previous
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
  end

  private

    def event_params
      params.require(:event).permit(:description, :date)
    end
end
