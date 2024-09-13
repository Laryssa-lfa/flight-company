# frozen_string_literal: true

class Airport < ApplicationRecord
  scope :by_iata, ->(iata) { where(iata: iata&.upcase) }

  def self.request_airports
    JSON.parse(File.read('spec/fixtures/airports.json'), symbolize_names: true)
  end
end
