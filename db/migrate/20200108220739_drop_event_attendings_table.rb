class DropEventAttendingsTable < ActiveRecord::Migration[6.0]
  def change
    remove_foreign_key :event_attendings, to_table: :events, column: :attended_event_id
    remove_foreign_key :event_attendings, to_table: :users, column: :event_attendee_id

    drop_table :event_attendings do |t|
      t.integer :attended_event_id
      t.integer :event_attendee_id

      t.timestamps
    end
  end
end
