class RemoveFlightIdFromFlightDetails < ActiveRecord::Migration[7.1]
  def change
    remove_column :flight_details, :flight_id, :bigint
  end
end
