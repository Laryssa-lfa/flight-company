# frozen_string_literal: true

class RemoveDepartureAndArrivalTimeFromFlightDetails < ActiveRecord::Migration[7.1]
  def change
    remove_column :flight_details, :departure_time, :string
    remove_column :flight_details, :arrival_time, :string
  end
end
