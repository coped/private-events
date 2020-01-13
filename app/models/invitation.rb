class Invitation < ApplicationRecord
    belongs_to :invited_event, class_name: "Event"
    belongs_to :event_invitee, class_name: "User"
    validates :invited_event_id, presence: true
    validates :event_invitee_id, presence: true
    
    def accept
        self.update(attending: true)
    end

    def decline
        self.update(attending: false)
    end
end
