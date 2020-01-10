class Event < ApplicationRecord
    belongs_to :creator, class_name: "User"
    has_many :invitations, foreign_key: :invited_event_id
    has_many :invitees, through: :invitations, source: :event_invitee

    scope :upcoming, -> { where('date >= ?', Time.now).order(date: :asc).includes(:creator) }
    scope :previous, -> { where('date < ?', Time.now).order(date: :desc).includes(:creator) }

    def attendees
        self.invitees.where('attending = ?', true)
    end
end
