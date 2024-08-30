# frozen_string_literal: true

class CreateFlightDetail < ActiveRecord::Migration[7.1]
  def change
    create_table :flight_details do |t|
      t.string :origin
      t.string :destiny
      t.string :origin_airport
      t.string :destination_airport
      t.integer :flight_number
      t.string :name_airline
      t.string :departure_time
      t.string :arrival_time

      t.timestamps
    end
  end
end
