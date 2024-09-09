# frozen_string_literal: true

class Airport < ApplicationRecord
  scope :by_iata, ->(iata) { where(iata: iata&.upcase) }

  def self.request_airports
    RequestHttpService.request(URI("#{ENV.fetch('URL_API')}/airports"))
  end
end
