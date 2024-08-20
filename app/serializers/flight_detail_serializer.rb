class FlightDetailSerializer < ActiveModel::Serializer
  attributes :origin,
             :destiny,
             :origin_airport,
             :destination_airport,
             :flight_number,
             :name_airline

  attribute :departure_time do
    object.departure_time
  end
  
  attribute :arrival_time do
    object.arrival_time
  end

  attribute :connections do
    search_connections
  end

  private

  def search_connections
    related_connections = RelatedConnection.where(
      flight_detail_id: object.id,
      flight_id: @instance_options[:flight_id]
    )
    find_connection(related_connections).compact
  end

  def find_connection(connections)
    connections.map do |connection|
      find_flight_detail(connection) unless connection.connection_id.nil?
    end
  end

  def find_flight_detail(obj)
    connection_data(FlightDetail.find(obj.connection_id))
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
