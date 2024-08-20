class FlightDetailSerializer < ActiveModel::Serializer
  attributes :origin,
             :destiny,
             :origin_airport,
             :destination_airport

  attribute :departure_time do
    object.departure_time
  end
  
  attribute :arrival_time do
    object.arrival_time
  end

  attribute :connections do
    find_connections
  end

  private

  def find_connections
    connections = FlightDetail.where(connection_id: object.id, flight_id: @instance_options[:flight_id])
    connections.map do |connection|
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
