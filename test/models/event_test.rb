require 'test_helper'

class EventTest < ActiveSupport::TestCase
  def setup
    @user = users(:example)
    @another_user = users(:user_1)
    @event = @user.created_events.create!(description: "foobar", date: Time.now)
  end

  test "upcoming events should be included in Event.upcoming scope" do
    assert_difference -> { Event.upcoming.count }, 1 do
      @upcoming_event = @user.created_events.create!(description: "foobar", date: Time.now + 100)
    end
    assert_includes Event.upcoming, @upcoming_event
  end

  test "previous events should be included in Event.previous scope" do
    assert_difference -> { Event.previous.count }, 1 do
      @previous_event = @user.created_events.create!(description: "foobar", date: Time.now - 100)
    end
    assert_includes Event.previous, @previous_event
  end

  test "should return attendees" do
    assert_difference -> { @event.attendees.count }, 1 do
      @event.invitations.create!(event_invitee: @another_user, attending: true)
    end
    assert_equal @event.attendees.count, Invitation.where('invited_event_id = :event_id AND attending = :true',
                                                         { event_id: @event.id, true: true }).count
  end
end
