# frozen_string_literal: true

class FlightSerializer < ActiveModel::Serializer
  attribute :fare_category

  attribute :formatted_price, key: :price

  attribute :flight_details do
    object.flight_details.uniq.map do |obj|
      FlightDetailSerializer.new(obj, flight_id: object.id).as_json
    end
  end
end
