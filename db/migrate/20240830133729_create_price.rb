# frozen_string_literal: true

class CreatePrice < ActiveRecord::Migration[7.1]
  def change
    create_table :prices do |t|
      t.integer :air_miles
      t.string :currency
      t.decimal :value, precision: 10, scale: 2
      t.string :formatted_price
      t.references :flight, null: false, foreign_key: true

      t.timestamps
    end
  end
end
