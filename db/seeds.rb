if Rails.env.development? || Rails.env.test?
  require "factory_bot"

  3.times do |index|
    FactoryBot.create(
      :related_connection,
      {
        flight_id: FactoryBot.create(:price).flight_id,
        flight_detail_id: FactoryBot.create(:flight_detail).id,
        connection_id: nil
      }
    )
  end
  FactoryBot.create(:airport)
  FactoryBot.create(
    :airport,
    iata: 'GRU',
    name: 'São Paulo/Guarulhos–Governador André Franco Montoro International Airport',
    location: 'São Paulo'
  )
end
