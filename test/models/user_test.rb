require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:example)
    @another_user = users(:user_1)
    @upcoming_event = @user.created_events.create!(name: "foo",
                                                   description: "foo description",
                                                   date: Time.now + 200,
                                                   location: "foo location")
    @previous_event = @user.created_events.create!(name: "bar",
                                                   description: "bar description",
                                                   date: Time.now - 200,
                                                   location: "bar location")
  end

  test "should not accept empty username" do
    @user.username = ""
    assert_not @user.valid?
  end

  test "should not accept username exceeding char limit" do
    @user.username = "a" * 256
    assert_not @user.valid?
  end

  test "should not accept existing username" do
    new_user = User.new(username: @user.username)
    assert_not new_user.valid?
  end

  test "should enfore username case insensitivity" do
    new_user = User.new(username: @user.username.upcase)
    assert_not new_user.valid?
    new_user = User.new(username: @user.username.capitalize)
    assert_not new_user.valid?
  end

  test "should return users upcoming events" do
    assert_difference -> { @user.upcoming_events.count }, 1 do
      @user.created_events.create!(name: "baz",
                                   description: "baz description",
                                   date: Time.now + 100,
                                   location: "baz location")
    end
    assert_includes @user.upcoming_events, Event.last
    assert_includes @user.upcoming_events, @upcoming_event
  end

  test "should return users previous events" do
    assert_difference -> { @user.previous_events.count }, 1 do
      @user.created_events.create!(name: "baz",
                                   description: "baz description",
                                   date: Time.now - 100,
                                   location: "baz location")
    end
    assert_includes @user.previous_events, Event.last
    assert_includes @user.previous_events, @previous_event
  end

  test "should return whether user is invited" do
    @upcoming_event.invitations.create!(event_invitee: @another_user)
    assert @another_user.invited?(@upcoming_event)
    assert_not @another_user.invited?(@previous_event)
  end

  test "should return true if user is invited to event" do
    @upcoming_event.invitations.create(event_invitee: @another_user)
    assert @another_user.invited?(@upcoming_event)
  end

  test "should return false if user in not invited to event" do
    assert_not @another_user.invited?(@upcoming_event)
  end
end
