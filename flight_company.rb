# frozen_string_literal: true

require './flight_validator_service'
require './flight_data_service'

ARRIVAL_RESPONSE = %w[S s sim Sim SIM].freeze

origin_airport = nil
destination_airport = nil
departure_time = nil
arrival_time = nil

def airport(type_airport)
  puts "\n- Qual é o aeroporto de #{type_airport}? [Formato: abreviado com 3 letras, por exemplo: GRU]"
  gets.chomp
end

def date(type_date)
  puts "\n- Qual a data que deseja #{type_date}? [Formato: dd/mm/aaaa]"
  gets.chomp
end

puts '==========================================='
puts '   Projeto de Companhia Aérea - Rebase'

origin_airport = FlightValidatorService.execute(airport('partida')).valid_airport while origin_airport.nil?

while destination_airport.nil?
  destination_airport = FlightValidatorService.execute(airport('destino')).valid_airport(origin_airport)
end

departure_time = FlightValidatorService.execute(date('partir')).valid_date while departure_time.nil?

puts "\n- Deseja informar a data de retorno? S/N"
arrival = gets.chomp

if ARRIVAL_RESPONSE.include?(arrival)
  arrival_time = FlightValidatorService.execute(date('retornar')).valid_date(departure_time) while arrival_time.nil?
end

FlightDataService.execute(
  {
    origin_airport: origin_airport,
    destination_airport: destination_airport,
    departure_time: departure_time,
    arrival_time: arrival_time
  }
).flight_itineraries
