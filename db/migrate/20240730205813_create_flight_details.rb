class CreateFlightDetails < ActiveRecord::Migration[7.1]
  def change
    create_table :flight_details do |t|
      t.string :origin
      t.string :destiny
      t.string :origin_airport
      t.string :destination_airport
      t.datetime :departure_time
      t.datetime :arrival_time
      t.string :seat_number
      t.integer :flight_number
      t.string :name_airline
      t.references :flight, null: false, foreign_key: true
      t.references :connections, foreign_key: { to_table: :flight_details }

      t.timestamps
    end
  end
end
