class AddDepartureTimeToFlightDetails < ActiveRecord::Migration[7.1]
  def change
    add_column :flight_details, :departure_time, :string
  end
end
