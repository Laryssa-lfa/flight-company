# frozen_string_literal: true

class FlightDetailSerializer < ActiveModel::Serializer
  attributes :origin,
             :destiny,
             :origin_airport,
             :destination_airport,
             :flight_number,
             :name_airline,
             :departure_time,
             :arrival_time

  attribute :connections do
    find_connections
  end

  private

  def find_connections
    FlightDetail.find_connections(object).map do |connection|
      connection_data(connection)
    end
  end

  def connection_data(obj)
    {
      origin: obj.origin,
      destiny: obj.destiny,
      origin_airport: obj.origin_airport,
      destination_airport: obj.destination_airport,
      departure_time: obj.departure_time,
      arrival_time: obj.arrival_time,
      flight_number: obj.flight_number,
      name_airline: obj.name_airline
    }
  end
end
