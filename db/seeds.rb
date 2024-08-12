# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Flights
flight = Flight.find_or_create_by!(fare_category: 0)
executive_flight = Flight.find_or_create_by!(fare_category: 1)
first_class_flight = Flight.find_or_create_by!(fare_category: 2)

# Price the flights
Price.find_or_create_by!({
  air_miles: 13.000, currency: nil, value: nil, flight_id: flight.id
})
Price.find_or_create_by!({
  air_miles: nil, currency: 'real', value: '1500,00', flight_id: executive_flight.id
})
Price.find_or_create_by!({
  air_miles: nil, currency: 'dólar', value: '1000', flight_id: first_class_flight.id
})

# Flight details the flights
FlightDetail.find_or_create_by!({
  flight_id: flight.id,
  origin: 'João Pessoa',
  destiny: 'São Paulo',
  origin_airport: 'JPA',
  destination_airport: 'GRU',
  departure_time: Date.today,
  arrival_time: (Date.today + 3),
  flight_number: '1313',
  name_airline: 'Rebase Airlines',
  connection_id: nil
})
detail_executive = FlightDetail.find_or_create_by!({
  flight_id: executive_flight.id,
  origin: 'João Pessoa',
  destiny: 'Belo Horizonte',
  origin_airport: 'JPA',
  destination_airport: 'CNF',
  departure_time: Date.today,
  arrival_time: (Date.today + 5),
  flight_number: '1313',
  name_airline: 'Rebase Airlines',
  connection_id: nil
})
detail_first_class = FlightDetail.find_or_create_by!({
  flight_id: first_class_flight.id,
  origin: 'João Pessoa',
  destiny: 'Madrid',
  origin_airport: 'JPA',
  destination_airport: 'MAD',
  departure_time: Date.today,
  arrival_time: (Date.today + 10),
  flight_number: '1313',
  name_airline: 'International Airlines',
  connection_id: nil
})

# Connections the flight details
detail_executive_connection1 = FlightDetail.find_or_create_by!(
  {
    flight_id: executive_flight.id,
    origin: 'João Pessoa',
    destiny: 'São Paulo',
    origin_airport: 'JPA',
    destination_airport: 'GRU',
    departure_time: Date.today,
    arrival_time: Date.today,
    flight_number: '1310',
    name_airline: 'Rebase Airlines',
    connection_id: detail_executive.id
  }
)
detail_executive_connection2 = FlightDetail.find_or_create_by!(
  {
    flight_id: executive_flight.id,
    origin: 'São Paulo',
    destiny: 'Belo Horizonte',
    origin_airport: 'GRU',
    destination_airport: 'CNF',
    departure_time: Date.today,
    arrival_time: Date.today,
    flight_number: '1010',
    name_airline: 'Rebase Airlines',
    connection_id: detail_executive.id
  }
)
detail_first_class_connection1 = FlightDetail.find_or_create_by!(
  {
    flight_id: first_class_flight.id,
    origin: 'João Pessoa',
    destiny: 'São Paulo',
    origin_airport: 'JPA',
    destination_airport: 'GRU',
    departure_time: Date.today,
    arrival_time: Date.today,
    flight_number: '1310',
    name_airline: 'Rebase Airlines',
    connection_id: detail_first_class.id
  }
)
detail_first_class_connection2 = FlightDetail.find_or_create_by!(
  {
    flight_id: first_class_flight.id,
    origin: 'São Paulo',
    destiny: 'Madrid',
    origin_airport: 'GRU',
    destination_airport: 'MAD',
    departure_time: Date.today,
    arrival_time: (Date.today + 1),
    flight_number: '753',
    name_airline: 'International Airlines',
    connection_id: detail_first_class.id
  }
)
