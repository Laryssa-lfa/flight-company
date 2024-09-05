# frozen_string_literal: true

require 'factory_bot'

FactoryBot.create(:airport, iata: 'JPA', location: 'João pessoa')
FactoryBot.create(:airport, iata: 'GRU', location: 'São Paulo')
FactoryBot.create(:airport, iata: 'MVD', location: 'Uruguai')

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
