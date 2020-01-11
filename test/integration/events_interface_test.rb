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
    assert_difference -> { Event.count }, 1 do
      post events_path, params: { event: { date: Time.now, description: "A description" } }
    end
    event = Event.last
    assert_redirected_to event_path(event)
    follow_redirect!
    assert_template "events/show"
    assert_match event.description, response.body
    get events_path
    Event.upcoming.each do |event|
      assert_select "a[href=?]", event_path(event)
    end
    Event.previous.each do |event|
      assert_select "a[href=?]", event_path(event)
    end
  end
end
