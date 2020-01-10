require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:example)
    @another_user = users(:user_1)
    @upcoming_event = @user.created_events.create!(description: "foobar", date: Time.now + 200)
    @previous_event = @user.created_events.create!(description: "foobar", date: Time.now - 200)
  end

  test "should return users upcoming events" do
    assert_difference -> { @user.upcoming_events.count }, 1 do
      @user.created_events.create!(description: "foobar", date: Time.now + 100)
    end
    assert_includes @user.upcoming_events, Event.last
    assert_includes @user.upcoming_events, @upcoming_event
  end

  test "should return users previous events" do
    assert_difference -> { @user.previous_events.count }, 1 do
      @user.created_events.create!(description: "foobar", date: Time.now - 100)
    end
    assert_includes @user.previous_events, Event.last
    assert_includes @user.previous_events, @previous_event
  end

  test "should return whether user is invited" do
    @upcoming_event.invitations.create!(event_invitee: @another_user)
    assert @another_user.invited?(@upcoming_event)
    assert_not @another_user.invited?(@previous_event)
  end
end
