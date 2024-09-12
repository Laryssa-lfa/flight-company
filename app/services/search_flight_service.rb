# frozen_string_literal: true

class SearchFlightService
  def initialize(arg)
    @origin_airport = arg[:origin_airport]
    @destination_airport = arg[:destination_airport]
    @departure_time = arg[:departure_time]
    @arrival_time = arg[:arrival_time]
    @fare_category = arg[:fare_category]
  end

  def self.execute(arg)
    new(arg).itineraries
  end

  def itineraries
    return search_itineraries if flight_detail_valid?

    message_error
  end

  private

  attr_reader :origin_airport, :destination_airport, :departure_time, :arrival_time, :fare_category

  WITHOUT_FLIGHT = 'Temporariamente sem opções de voos!'

  def flight_detail_valid?
    new_flight_detail.valid?
  end

  def message_error
    new_flight_detail.errors.full_messages.to_json
  end

  def new_flight_detail
    @new_flight_detail ||= FlightDetail.new({
      origin_airport: origin_airport,
      destination_airport: destination_airport,
      departure_time: departure_time,
      arrival_time: arrival_time
    })
  end

  def search_itineraries
    itineraries = FlightDetail.find_flight_details(origin_airport, destination_airport, departure_time)
    itineraries.any? ? search_flights(itineraries) : build_itineraries
  end

  def search_flights(itineraries)
    itineraries.map(&:flights).flatten
  end

  def build_itineraries
    url = build_url('search-one-way') if arrival_time.nil?
    url ||= build_url('search-roundtrip')

    request_flights_api(URI(url))
  end

  def request_flights_api(url)
    response = RequestHttpService.request(url)
    return WITHOUT_FLIGHT.to_json if !response[:status] || response[:data][:itineraries].empty?

    FlightDataService.execute(response[:data][:itineraries], fare_category)
  end

  def format_date(date)
    Date.parse(date).strftime('%Y-%m-%d') unless date.nil?
  end

  def format_airport(airport)
    airport.upcase
  end

  def build_url(intineration)
    "#{ENV.fetch('URL_API')}/#{intineration}?fromEntityId=#{format_airport(origin_airport)}" \
      "&toEntityId=#{format_airport(destination_airport)}&departDate=#{format_date(departure_time)}" \
      "&returnDate=#{format_date(arrival_time)}&cabinClass=economy"
  end
end
