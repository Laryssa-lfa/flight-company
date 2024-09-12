# frozen_string_literal: true

require 'factory_bot'

if Airport.count.zero?
  airports = Airport.request_airports[:data]

  unless airports.nil?
    airports.each do |obj|
      Airport.find_or_create_by!(
        iata: obj[:iata],
        name: obj[:name],
        location: obj[:location]
      )
    end
  end
end

if Rails.env.development?
  3.times do |_index|
    FactoryBot.create(
      :related_connection,
      flight_id: FactoryBot.create(:price).flight_id,
      flight_detail_id: FactoryBot.create(:flight_detail).id,
      connection_id: nil
    )
  end
end
