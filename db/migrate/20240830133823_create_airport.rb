# frozen_string_literal: true

class CreateAirport < ActiveRecord::Migration[7.1]
  def change
    create_table :airports do |t|
      t.string :iata
      t.string :name
      t.string :location

      t.timestamps
    end
  end
end
