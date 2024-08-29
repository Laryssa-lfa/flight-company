class AddConnectionIdToFlightDetails < ActiveRecord::Migration[7.1]
  def change
    add_column :flight_details, :connection_id, :integer
  end
end
