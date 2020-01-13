require 'test_helper'

class EventTest < ActiveSupport::TestCase
  def setup
    @user = users(:example)
    @another_user = users(:user_1)
    @event = @user.created_events.create!(name: "foo",
                                          description: "foo description",
                                          date: Time.now,
                                          location: "foo location")
  end

  test "should not accept empty event name" do
    @event.name = ""
    assert_not @event.valid?
  end

  test "should not accept event name exceeding char limit" do
    @event.name = "a" * 256
    assert_not @event.valid?
  end

  test "should not accept empty event description" do
    @event.description = ""
    assert_not @event.valid?
  end

  test "should not accept event description exceeding char limit" do
    @event.description = "a" * 40_001
    assert_not @event.valid?
  end

  test "should not accept empty event date" do
    @event.date = ""
    assert_not @event.valid?
  end

  test "shoud not accept empty event location" do
    @event.location = ""
    assert_not @event.valid?
  end

  test "should not accept event location exceeding char limit" do
    @event.location = "a" * 256
    assert_not @event.valid?
  end

  test "should not accept empty creator id" do
    @event.creator_id = ""
    assert_not @event.valid?
  end

  test "upcoming events should be included in Event.upcoming scope" do
    assert_difference -> { Event.upcoming.count }, 1 do
      @upcoming_event = @user.created_events.create!(name: "bar",
                                                     description: "bar description",
                                                     date: Time.now + 100,
                                                     location: "bar location")
    end
    assert_includes Event.upcoming, @upcoming_event
  end

  test "previous events should be included in Event.previous scope" do
    assert_difference -> { Event.previous.count }, 1 do
      @previous_event = @user.created_events.create!(name: "bar",
                                                     description: "bar description",
                                                     date: Time.now - 100,
                                                     location: "bar location")
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
