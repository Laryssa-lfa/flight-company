# frozen_string_literal: true

class FlightSerializer < ActiveModel::Serializer
  attribute :fare_category

  attribute :price do
    object.price&.formatted_price
  end

  attribute :flight_details do
    object.flight_details.uniq.map do |obj|
      FlightDetailSerializer.new(obj, flight_id: object.id).as_json
    end
  end
end
