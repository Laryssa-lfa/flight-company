class CreateRelatedConnection < ActiveRecord::Migration[7.1]
  def change
    create_table :related_connections do |t|
      t.belongs_to :flight_detail, null: false, foreign_key: true
      t.belongs_to :flight, null: false, foreign_key: true

      t.timestamps
    end
  end
end
