class FlightSerializer < ActiveModel::Serializer
  attribute :fare_category

  attribute :price do
    object.price.formatted_price
  end

  attribute :flight_details do
    object.flight_details.map do |obj|
      FlightDetailSerializer.new(obj, flight_id: object.id)
    end
  end
end
