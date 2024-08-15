class AddArrivalTimeToFlightDetails < ActiveRecord::Migration[7.1]
  def change
    add_column :flight_details, :arrival_time, :string
  end
end
