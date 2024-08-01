class CreateConnections < ActiveRecord::Migration[7.1]
  def change
    create_table :connections do |t|
      t.references :flight, null: false, foreign_key: true
      t.references :flight_detail, null: false, foreign_key: true

      t.timestamps
    end
  end
end
