class FlightDetail < ApplicationRecord
  has_many :related_connections
  has_many :flights, through: :related_connections
end
