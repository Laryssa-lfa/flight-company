class CreateFlights < ActiveRecord::Migration[7.1]
  def change
    create_table :flights do |t|
      t.column :fare_category, :integer, default: 0

      t.timestamps
    end
  end
end
