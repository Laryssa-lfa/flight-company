# frozen_string_literal: true

class FlightDataService
  def initialize(arg, fare_category)
    @arg = arg
    @fare_category = fare_category
  end

  def self.execute(arg, fare_category)
    new(arg, fare_category).flight_datas
  end

  def flight_datas
    arg.map do |itinerary|
      build_data(itinerary)
    end
  end

  private

  attr_reader :arg, :fare_category

  def build_data(obj)
    flight = Flight.create(fare_category: fare_category.presence || 'economic')
    build_price(flight.id, obj[:price])
    itineraries(flight.id, obj[:legs])
    flight
  end

  def build_price(flight_id, obj)
    Price.create({
      flight_id: flight_id,
      air_miles: obj[:air_miles],
      currency: obj[:currency],
      value: obj[:raw],
      formatted_price: obj[:formatted]
    })
  end

  def itineraries(flight_id, legs)
    legs.each do |leg|
      flight_detail = build_flight_detail(leg)
      RelatedConnection.find_or_create_by!(
        flight_id: flight_id,
        flight_detail_id: flight_detail.id
      )
      build_connections(leg[:segments], flight_id, flight_detail.id) if (leg[:stopCount]).positive?
    end
  end

  def build_flight_detail(obj)
    flight_detail = FlightDetail.find_or_create_by!({
      origin: obj.dig(:origin, :name),
      destiny: obj.dig(:destination, :name),
      origin_airport: obj.dig(:origin, :displayCode),
      destination_airport: obj.dig(:destination, :displayCode),
      departure_time: obj[:departure],
      arrival_time: obj[:arrival]
    })
    number_and_airline(flight_detail, obj)
  end

  def number_and_airline(flight_detail, obj)
    if one_way_trip?(obj)
      flight_detail.flight_number = obj.dig(:segments, 0, :flightNumber)
      flight_detail.name_airline = obj.dig(:segments, 0, :operatingCarrier, :name)
    elsif !segments?(obj)
      flight_detail.flight_number = obj[:flightNumber]
      flight_detail.name_airline = obj.dig(:operatingCarrier, :name)
    end
    flight_detail.save
    flight_detail
  end

  def build_connections(segments, flight_id, flight_detail_id)
    segments.each do |segment|
      flight_segment = build_flight_detail(segment)
      RelatedConnection.find_or_create_by!(
        flight_id: flight_id,
        flight_detail_id: flight_detail_id,
        connection_id: flight_segment.id
      )
    end
  end

  def one_way_trip?(obj)
    segments?(obj) && (obj[:stopCount]).zero?
  end

  def segments?(obj)
    obj[:segments].present?
  end
end
