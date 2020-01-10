require 'test_helper'

class InvitationTest < ActiveSupport::TestCase
  def setup
    @user = users(:example)
    @event = events(:user_1_event)
  end
  
  test "accepting invite should add them to attended event" do
    invitation = @event.invitations.create!(event_invitee: @user)
    assert_nil invitation.attending
    assert_difference -> { @event.attendees.count }, 1 do
      invitation.accept
    end
    assert invitation.attending
    assert_includes @event.attendees, @user
  end
  
  test "declining invite should not add them to event" do
    invitation = @event.invitations.create!(event_invitee: @user)
    assert_nil invitation.attending
    assert_no_difference -> { @event.attendees.count }, 1 do
      invitation.decline
    end
    assert_not invitation.attending
    assert_not_includes @event.attendees, @user
  end
end
