class Event < ApplicationRecord
    belongs_to :creator, class_name: "User"

    def Event.get_all_events
        self.all.order(created_at: :desc)
    end
end
