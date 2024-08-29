class RemoveArrivalTimeFromFlightDetails < ActiveRecord::Migration[7.1]
  def change
    remove_column :flight_details, :arrival_time, :datetime
  end
end
