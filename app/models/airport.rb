# frozen_string_literal: true

class Airport < ApplicationRecord
  scope :by_iata, ->(iata) { where(iata: iata&.upcase) }

  def prepare_db_for_airports
    save_db_airports if Airport.count.zero?
  end

  private

  def save_db_airports
    request_airports.each do |obj|
      Airport.find_or_create_by!(
        iata: obj[:iata],
        name: obj[:name],
        location: obj[:location]
      )
    end
  end

  def request_airports
    RequestHttpService.request(URI("#{ENV.fetch('URL_API')}/airports"))
  end
end
