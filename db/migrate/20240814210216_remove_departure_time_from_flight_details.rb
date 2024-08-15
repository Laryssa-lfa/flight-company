class RemoveDepartureTimeFromFlightDetails < ActiveRecord::Migration[7.1]
  def change
    remove_column :flight_details, :departure_time, :datetime
  end
end
