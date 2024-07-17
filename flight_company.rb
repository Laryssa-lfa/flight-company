# frozen_string_literal: true

require './flight_validator_service'
require './flight_data_service'

ARRIVAL_RESPONSE = %w[S s sim Sim SIM].freeze

origin_airport = ''
destination_airport = ''
departure_time = ''
arrival_time = ''

puts '==========================================='
puts '   Projeto de Companhia Aérea - Rebase'

while origin_airport.empty?
  puts "\n- Qual é o aeroporto de origem? [Formato: abreviado com 3 letras, por exemplo: GRU]"
  origin = gets.chomp
  origin_airport = FlightValidatorService.execute(origin).valid_airport
end

while destination_airport.empty?
  puts "\n- Qual é o aeroporto de destino? [Formato: abreviado com 3 letras, por exemplo: GRU]"
  destination = gets.chomp
  destination_airport = FlightValidatorService.execute(destination).valid_airport(origin)
end

while departure_time.empty?
  puts "\n- Qual a data que deseja partir? [Formato: dd/mm/aaaa]"
  date = gets.chomp
  departure_time = FlightValidatorService.execute(date).valid_date
end

puts "\n- Deseja informar a data de retorno? S/N"
arrival = gets.chomp

if ARRIVAL_RESPONSE.include?(arrival)
  while arrival_time.empty?
    puts "\n- Qual será a data de retorno? [Formato: dd/mm/aaaa]"
    date = gets.chomp
    arrival_time = FlightValidatorService.execute(date).valid_date(departure_time)
  end
end

if ARRIVAL_RESPONSE.include?(arrival)
  FlightDataService.execute(
    {
      origin_airport: origin_airport,
      destination_airport: destination_airport,
      departure_time: departure_time,
      arrival_time: arrival_time
    }
  ).flight_itineraries
else
  FlightDataService.execute(
    {
      origin_airport: origin_airport,
      destination_airport: destination_airport,
      departure_time: departure_time,
      arrival_time: nil
    }
  ).flight_itineraries
end
