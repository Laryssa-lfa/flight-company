class AddFlightRefToFlightDetails < ActiveRecord::Migration[7.1]
  def change
    add_reference :flight_details, :flight, null: false, foreign_key: true
  end
end
