require 'test_helper'

class InvitationsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:example)
    @event = events(:user_1_event)
    @invitation = @event.invitations.create!(event_invitee: @user)
  end

  test "should get show" do
    get invitation_path(@invitation)
    assert_response :success
  end
end
