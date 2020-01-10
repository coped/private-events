class ChangeAttendingDefaultToNull < ActiveRecord::Migration[6.0]
  def change
    change_column_default :invitations, :attending, from: false, to: nil
  end
end
