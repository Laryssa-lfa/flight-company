# frozen_string_literal: true

class CreateRelatedConnection < ActiveRecord::Migration[7.1]
  def change
    create_table :related_connections do |t|
      t.references :flight_detail, null: false, foreign_key: true
      t.references :flight, null: false, foreign_key: true
      t.integer :connection_id

      t.timestamps
    end
  end
end
