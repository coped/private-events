class CreateInvitationsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :invitations do |t|
      t.integer :invited_event_id
      t.integer :event_invitee_id
      t.boolean :attending, default: false

      t.timestamps
    end
    add_foreign_key :invitations, :events, column: :invited_event_id
    add_foreign_key :invitations, :users, column: :event_invitee_id
  end
end
