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
      flight_detail = build_flight_detail(leg, flight_id, index)
      RelatedConnection.find_or_create_by!(
        flight_id: flight_id,
        flight_detail_id: flight_detail.id
      )
      build_connections(leg[:segments], flight_id, flight_detail.id) if leg[:stopCount] > 0
    end
  end

  def build_flight_detail(obj, flight_id, index = nil, flight_detail_id = nil)
    FlightDetail.find_or_create_by!({
      flight_id: flight_id,
      origin: obj.dig(:origin, :name),
      destiny: obj.dig(:destination, :name),
      origin_airport: obj.dig(:origin, :displayCode),
      destination_airport: obj.dig(:destination, :displayCode),
      departure_time: format_date(obj[:departure]),
      arrival_time: format_date(obj[:arrival]),
      flight_number: save_flight_number(obj, index),
      name_airline: save_name_airline(obj, index),
      connection_id: save_connection_id(obj, flight_detail_id)
    })
  end

  def save_flight_number(obj, index)
    if has_segments?(obj) && obj[:stopCount] == 0
      obj.dig(:segments, index, :flightNumber)
    elsif !has_segments?(obj)
      obj.dig(:flightNumber)
    end
  end

  def save_name_airline(obj, index)
    if has_segments?(obj) && obj[:stopCount] == 0
      obj.dig(:segments, index, :operatingCarrier, :name)
    elsif !has_segments?(obj)
      obj.dig(:operatingCarrier, :name)
    end
  end

  def save_connection_id(obj, flight_detail_id)
    return flight_detail_id unless has_segments?(obj)
  end

  def build_connections(segments, flight_id, flight_detail_id)
    segments.each do |segment|
      build_flight_detail(segment, flight_id, nil, flight_detail_id)
    end
  end

  def format_date(date)
    DateTime.parse(date).strftime('%d/%m/%Y - %H:%M:%S')
  end

  def has_segments?(obj)
    obj[:segments].present?
  end
end
