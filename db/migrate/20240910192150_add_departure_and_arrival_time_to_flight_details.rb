# frozen_string_literal: true

class AddDepartureAndArrivalTimeToFlightDetails < ActiveRecord::Migration[7.1]
  def change
    add_column :flight_details, :departure_time, :datetime
    add_column :flight_details, :arrival_time, :datetime
  end
end
