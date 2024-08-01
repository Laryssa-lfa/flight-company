class FlightDetail < ApplicationRecord
  has_many :flights, through: :connections
end
