# frozen_string_literal: true

class FlightDetail < ApplicationRecord
  has_many :related_connections, dependent: nil
  has_many :flights, through: :related_connections
end
