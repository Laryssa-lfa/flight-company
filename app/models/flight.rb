class Flight < ApplicationRecord
  has_one :price
  has_many :related_connections
  has_many :flight_details, through: :related_connections

  enum :fare_category, { economic: 0, executive: 1, first_class: 2 }, default: :economic
end
