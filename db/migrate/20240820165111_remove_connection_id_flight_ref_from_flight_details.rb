class RemoveConnectionIdFlightRefFromFlightDetails < ActiveRecord::Migration[7.1]
  def change
    remove_column :flight_details, :connection_id, :integer
    remove_reference :flight_details, :flight, null: false, foreign_key: true
  end
end
