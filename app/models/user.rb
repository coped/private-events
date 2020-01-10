class User < ApplicationRecord
    has_many :created_events, foreign_key: :creator_id, class_name: "Event"
    has_many :invitations, foreign_key: :event_invitee_id
    has_many :invited_events, through: :invitations

    def upcoming_events
        self.created_events.where('date >= ?', Time.now).order(date: :asc)
    end

    def previous_events 
        self.created_events.where('date < ?', Time.now).order(date: :desc)
    end

    def invited?(event)
        Invitation.where('invited_event_id = :event_id AND event_invitee_id = :user_id', 
                        { event_id: event.id, user_id: self.id }).any?
    end
end
