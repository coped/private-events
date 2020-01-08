class User < ApplicationRecord
    has_many :created_events, foreign_key: :creator_id, class_name: "Event"
    has_many :event_attendings, foreign_key: :event_attendee_id
    has_many :attended_events, through: :event_attendings

    def upcoming_events
        self.created_events.where('date >= ?', Time.now)
    end

    def previous_events 
        self.created_events.where('date < ?', Time.now)
    end
end
