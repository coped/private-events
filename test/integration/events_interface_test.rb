require 'test_helper'

class EventsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:example)
  end

  test "events interface" do
    log_in_as(@user)
    get root_path
    assert_select "a[href=?]", new_event_path
    get new_event_path
    # Submitting an invalid event
    assert_no_difference -> { Event.count } do
      post events_path, params: { event: { name: "",
                                           description: "",
                                           date: Time.now,
                                           location: "" } }
    end
    assert_template 'events/new'
    assert_not flash.empty?
    # Submitting a valid event
    assert_difference -> { Event.count }, 1 do
      post events_path, params: { event: { name: "foobar",
                                           description: "A description",
                                           date: Time.now,
                                           location: "foobar" } }
    end
    assert_not flash.empty?
    event = Event.last
    assert_redirected_to event_path(event)
    follow_redirect!
    assert_template "events/show"
    assert_match event.name, response.body
    assert_match event.description, response.body
    assert_match event.location, response.body
    assert_select "a[href=?]", user_path(event.creator)
    # Event index
    get events_path
    Event.upcoming.each do |event|
      assert_select "a[href=?]", event_path(event)
    end
    Event.previous.each do |event|
      assert_select "a[href=?]", event_path(event)
    end
  end
end
