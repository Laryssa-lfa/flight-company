# frozen_string_literal: true

require 'test/unit'
require 'minitest/mock'
require 'date'
require './flight_validator_service'

class FlightCompanyTest < Test::Unit::TestCase
  def setup
    @initial_date = Date.today.strftime('%d/%m/%Y')
    @final_date = (Date.today + 1).strftime('%d/%m/%Y')
    @past_date = (Date.today - 1).strftime('%d/%m/%Y')
    @flight_data_service = Minitest::Mock.new
  end

  def valid_airport_service(origin_airport, destination_airport = nil)
    FlightValidatorService.execute(origin_airport).valid_airport(destination_airport)
  end

  def valid_date_service(departure_time, date = nil)
    FlightValidatorService.execute(departure_time).valid_date(date)
  end

  def data_flight(arrival_time = nil)
    {
      origin_airport: 'jpa',
      destination_airport: 'gru',
      departure_time: @initial_date,
      arrival_time: arrival_time
    }
  end

  def test_text_validation
    assert_equal('jpa', valid_airport_service('jpa'))
    assert_equal('jpa', valid_airport_service('jpa', 'gru'))
    assert_nil(valid_airport_service('jp3'))
    assert_nil(valid_airport_service('jpà'))
    assert_nil(valid_airport_service('j.a'))
    assert_nil(valid_airport_service('xxx'))
    assert_nil(valid_airport_service('jpa', 'jpa'))
  end

  def test_departure_date_validation
    assert_equal(@initial_date, valid_date_service(@initial_date))
    assert_nil(valid_date_service(@past_date))
    assert_nil(valid_date_service('13-07-2024'))
    assert_nil(valid_date_service('13/2/2024'))
    assert_nil(valid_date_service('31/06/2024'))
  end

  def test_arrival_date_validation
    assert_equal(@final_date, valid_date_service(@final_date, @initial_date))
    assert_nil(valid_date_service(@past_date, @initial_date))
    assert_nil(valid_date_service(@past_date))
    assert_nil(valid_date_service('13-07-2024'))
    assert_nil(valid_date_service('13/2/2024'))
    assert_nil(valid_date_service('31/06/2024'))
  end

  def test_itinerary_flight
    @flight_data_service.expect(:execute, true, [data_flight])
    @flight_data_service.expect(:flight_itineraries, 'one_way_response')
    assert_equal('one_way_response', @flight_data_service.flight_itineraries)
  end

  def test_itineraries_flights
    @flight_data_service.expect(:execute, true, [data_flight(@final_date)])
    @flight_data_service.expect(:flight_itineraries, 'roundtrip_response')
    assert_equal('roundtrip_response', @flight_data_service.flight_itineraries)
  end
end
