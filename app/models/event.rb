class Event < ApplicationRecord
    belongs_to :creator, class_name: "User"
    has_many :event_attendings, foreign_key: :attended_event_id
    has_many :attendees, through: :event_attendings, source: :event_attendee

    scope :upcoming, -> { where('date >= ?', Time.now).order(date: :asc).includes(:creator) }
    scope :previous, -> { where('date < ?', Time.now).order(date: :desc).includes(:creator) }
end
