# frozen_string_literal: true

FactoryBot.define do
  factory :flight_detail do
    origin { 'João Pessoa' }
    destiny { 'São Paulo' }
    origin_airport { 'JPA' }
    destination_airport { 'GRU' }
    flight_number { rand(60) }
    name_airline { 'Rebase Airline' }
    departure_time { DateTime.current.strftime('%d/%m/%Y - %H:%M:%S') }
    arrival_time { (DateTime.current + 2).strftime('%d/%m/%Y - %H:%M:%S') }
  end
end
