class CreateEventAttendings < ActiveRecord::Migration[6.0]
  def change
    create_table :event_attendings do |t|
      t.integer :attended_event_id
      t.integer :event_attendee_id

      t.timestamps
    end
    add_foreign_key :event_attendings, :events, column: :attended_event_id
    add_foreign_key :event_attendings, :users, column: :event_attendee_id
  end
end
