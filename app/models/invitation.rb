class Invitation < ApplicationRecord
    belongs_to :invited_event, class_name: "Event"
    belongs_to :event_invitee, class_name: "User"

    def accept
        self.update(attending: true)
    end

    def decline
        self.update(attending: false)
    end
end
