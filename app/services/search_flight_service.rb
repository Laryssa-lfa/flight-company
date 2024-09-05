# frozen_string_literal: true

class SearchFlightService
  def initialize(arg)
    @arg = arg
  end

  def self.execute(arg)
    new(arg).itineraries
  end

  def itineraries
    return search_itineraries if flight_detail_valid?

    message_error
  end

  private

  attr_reader :arg

  WITHOUT_FLIGHT = 'Temporariamente sem opções de voos!'

  def flight_detail_valid?
    new_flight_detail.valid?
  end

  def message_error
    new_flight_detail.errors.full_messages.to_json
  end

  def new_flight_detail
    @new_flight_detail ||= FlightDetail.new(arg)
  end

  def search_itineraries
    itineraries = FlightDetail.where(
      origin_airport: arg[:origin_airport],
      destination_airport: arg[:destination_airport]
    ).where('departure_time LIKE ?', format_date_bd(arg[:departure_time]))

    itineraries.any? ? search_flights(itineraries) : build_itineraries
  end

  def search_flights(itineraries)
    all_itineraries = itineraries.map(&:flights)
    all_itineraries.flatten
  end

  def build_itineraries
    url = build_url('search-one-way') if arg[:arrival_time].nil?
    url ||= build_url('search-roundtrip')

    request_flights_api(URI(url))
  end

  def request_flights_api(url)
    response = RequestHttpService.request(url)
    return WITHOUT_FLIGHT.to_json if !response[:status] || response[:data][:itineraries].empty?

    FlightDataService.execute(response[:data][:itineraries], arg[:fare_category])
  end

  def format_date_bd(date)
    "#{DateTime.parse(date).strftime('%d/%m/%Y')}%" unless date.nil?
  end

  def format_date(date)
    Date.parse(date).strftime('%Y-%m-%d') unless date.nil?
  end

  def format_airport(airport)
    airport.upcase
  end

  def build_url(intineration)
    "#{ENV.fetch('URL_API')}/#{intineration}?fromEntityId=#{format_airport(arg[:origin_airport])}" \
      "&toEntityId=#{format_airport(arg[:destination_airport])}&departDate=#{format_date(arg[:departure_time])}" \
      "&returnDate=#{format_date(arg[:arrival_time])}&cabinClass=economy"
  end
end
