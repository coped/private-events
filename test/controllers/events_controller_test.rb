require 'test_helper'

class EventsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:example)
    @event = @user.created_events.create!(name: "foobar",
                                          description: "foobar",
                                          date: Time.now,
                                          location: "foobar")
  end

  test "should get new" do
    log_in_as(@user)
    get new_event_path
    assert_template "events/new"
    assert_response :success
  end

  test "should get show" do
    get event_path(@event)
    assert_template "events/show"
    assert_response :success
  end

  test "should get index" do
    get events_path
    assert_template "events/index"
    assert_response :success
  end
end
