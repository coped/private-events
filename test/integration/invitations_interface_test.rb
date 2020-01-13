require 'test_helper'

class InvitationsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:example)
    @user_event = @user.created_events.create!(name:        "foobar",
                                               description: "foobar",
                                               date:        Time.now + 100,
                                               location:    "foobar")
    @different_user = users(:user_1)
    @different_user_event = @different_user.created_events.create!(name:        "foobar",
                                                                   description: "foobar",
                                                                   date:        Time.now + 100,
                                                                   location:    "foobar")
  end
  
  test "invitations interface" do
    log_in_as(@user)
    get event_path(@user_event)
    assert_select "form[action=?]", invitations_path
    # Sending invitation to non-existent user
    assert_no_difference -> { @user_event.invitations.count } do
      post invitations_path, params: { invitation: { event_invitee_id: 9999999, invited_event_id: @user_event.id } }
    end
    assert_redirected_to event_path(@user_event)
    follow_redirect!
    assert_not flash.empty?
    # Successfully sending an invitation
    assert_difference -> { @user_event.invitations.count }, 1 do
      post invitations_path, params: { invitation: { event_invitee_id: @different_user.id, invited_event_id: @user_event.id } }
    end
    assert_redirected_to event_path(@user_event)
    follow_redirect!
    assert_not flash.empty?
    # Recieving an invitation
    assert_difference -> { @user.invitations.count }, 1 do
      @invitation = @different_user_event.invitations.create!(event_invitee: @user)
    end
    @invitation.reload
    assert_nil @invitation.attending
    get user_path(@user)
    assert_select "a[href=?]", invitation_path(@invitation)
    get invitation_path(@invitation)
    assert_select "a[href=?]", event_path(@invitation.invited_event)
    assert_select "a[href=?]", user_path(@invitation.invited_event.creator)
    assert_match "Accept invitation", response.body
    assert_match "Decline invitation", response.body
    assert_match "Delete invitation", response.body
    # Accepting an invitation
    assert_difference -> { @different_user_event.attendees.count }, 1 do
      patch invitation_path(@invitation), params: { response: true }
    end
    @invitation.reload
    assert @invitation.attending
    assert_redirected_to invitation_path(@invitation)
    follow_redirect!
    assert_not flash.empty?
    assert_select "span.is-info"
    # Changing your mind and declining the invitation
    assert_difference -> { @different_user_event.attendees.count }, -1 do
      patch invitation_path(@invitation), params: { response: false }
    end
    @invitation.reload
    assert_not @invitation.attending
    assert_redirected_to invitation_path(@invitation)
    follow_redirect!
    assert_not flash.empty?
    assert_select "span.is-info"
    # Deleting the invitation
    assert_difference -> { @user.invitations.count }, -1 do
      delete invitation_path(@invitation)
    end
    assert_redirected_to user_path(@user)
    follow_redirect!
  end
end
