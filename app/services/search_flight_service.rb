class SearchFlightService
  def initialize(arg)
    @arg = arg
  end

  def self.execute(arg)
    new(arg).itineraries
  end

  def itineraries
    search_itineraries
  end

  private

  attr_reader :arg
  WITHOUT_FLIGHT = 'Temporariamente sem opções de voos!'.freeze

  def search_itineraries
    itineraries = FlightDetail.where(
      origin_airport: arg[:origin_airport],
      destination_airport: arg[:destination_airport]
    ).where("departure_time LIKE ?", format_date_bd(arg[:departure_time]))

    itineraries.any? ? search_flights(itineraries) : build_itineraries
  end

  def search_flights(itineraries)
    itineraries.map do |itinerary|
      itinerary.flights.first
    end
  end

  def build_itineraries
    url = build_url('search-one-way') if arg[:arrival_time].nil?
    url ||= build_url('search-roundtrip')

    request_flights_api(URI(url))
  end

  def request_flights_api(url)
    response = request_http(url)
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

  def request_http(url)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request['x-rapidapi-key'] = ENV.fetch('KEY_API')
    request['x-rapidapi-host'] = ENV.fetch('HOST_API')

    result = http.request(request).read_body
    JSON.parse(result, symbolize_names: true)
  end
end
