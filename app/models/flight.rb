# frozen_string_literal: true

class Flight < ApplicationRecord
  has_one :price, dependent: :destroy
  delegate :formatted_price, to: :price, allow_nil: true

  has_many :related_connections, dependent: :destroy
  has_many :flight_details, through: :related_connections

  enum :fare_category, { economic: 0, executive: 1, first_class: 2 }, default: :economic
end
