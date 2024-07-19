# frozen_string_literal: true

require 'test/unit'
require 'minitest/mock'
require 'date'
require './flight_validator_service'

# rubocop:disable all
class FlightCompanyTest < Test::Unit::TestCase
  def test_text_validation
    def service(origin_airport, destination_airport = nil)
      FlightValidatorService.execute(origin_airport).valid_airport(destination_airport)
    end

    assert_equal('jpa', service('jpa'))
    assert_equal('jpa', service('jpa', 'gru'))
    assert_empty(service('jp3'))
    assert_empty(service('jpà'))
    assert_empty(service('j.a'))
    assert_empty(service('xxx'))
    assert_empty(service('jpa', 'jpa'))
  end

  def test_date_validation
    def service(departure_time, date = nil)
      FlightValidatorService.execute(departure_time).valid_date(date)
    end

    initial_date = Date.today.strftime('%d/%m/%Y')
    final_date = (Date.today + 1).strftime('%d/%m/%Y')

    assert_equal(initial_date, service(initial_date))
    assert_equal(final_date, service(final_date, initial_date))
    assert_empty(service(initial_date, initial_date))
    assert_empty(service('13/07/2024'))
    assert_empty(service('13-07-2024'))
    assert_empty(service('13/2/2024'))
    assert_empty(service('31/06/2024'))
  end

  def test_summary_flights
    flight_data_service = Minitest::Mock.new

    # one way tests
    data_flight_one_way = {
      origin_airport: 'jpa',
      destination_airport: 'gru',
      departure_time: '17/07/2024'
    }

    flight_data_service.expect(:execute, true, [data_flight_one_way])
    flight_data_service.expect(:itineraries_one_way, 'one_way_response')
    assert_equal('one_way_response', flight_data_service.itineraries_one_way)

    # roundtrip tests
    data_flight_roundtrip = {
      origin_airport: 'jpa',
      destination_airport: 'gru',
      departure_time: data_flight_one_way[:destination_airport]
    }

    flight_data_service.expect(:execute, true, [data_flight_roundtrip])
    flight_data_service.expect(:itineraries_one_way, 'roundtrip_response', ['20/07/2024'])
    assert_equal('roundtrip_response', flight_data_service.itineraries_one_way('20/07/2024'))
  end
end
