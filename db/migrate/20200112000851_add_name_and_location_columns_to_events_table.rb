class AddNameAndLocationColumnsToEventsTable < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :name, :string
    add_column :events, :location, :string
  end
end
