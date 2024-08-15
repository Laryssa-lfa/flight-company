class FlightDataService
  def initialize(arg, fare_category)
    @arg = arg
    @fare_category = fare_category
  end

  def self.execute(arg, fare_category)
    new(arg, fare_category).flight_datas
  end

  def flight_datas
    arg.map do |obj|
      build_data(obj)
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
    legs.each_with_index do |leg, index|
      flight_detail = build_flight_detail(leg, index)
      RelatedConnection.find_or_create_by!(
        flight_id: flight_id,
        flight_detail_id: flight_detail.id
      )
      build_connections(leg[:segments], flight_detail.id) if leg[:stopCount] > 0
    end
  end

  def build_flight_detail(obj, index = nil)
    flight_detail = detail_create(obj)

    if obj[:segments].present? && obj[:stopCount] == 0
      airline_data(flight_detail, obj[:segments][index])
    elsif !obj[:segments].present?
      airline_data(flight_detail, obj)
    end

    flight_detail
  end

  def detail_create(obj)
    FlightDetail.find_or_create_by!({
      origin: obj.dig(:origin, :name),
      destiny: obj.dig(:destination, :name),
      origin_airport: obj.dig(:origin, :displayCode),
      destination_airport: obj.dig(:destination, :displayCode),
      departure_time: format_date(obj[:departure]),
      arrival_time: format_date(obj[:arrival])
    })
  end

  def airline_data(flight_detail, obj)
    flight_detail.flight_number = obj[:flightNumber]
    flight_detail.name_airline = obj.dig(:operatingCarrier, :name)
    flight_detail.save
  end

  def build_connections(segments, flight_detail_id)
    segments.each do |segment|
      flight_detail = build_flight_detail(segment)
      flight_detail.connection_id = flight_detail_id
      flight_detail.save
    end
  end

  def format_date(date)
    DateTime.parse(date).strftime('%d/%m/%Y - %H:%M:%S')
  end
end
