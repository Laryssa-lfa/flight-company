# frozen_string_literal: true

require 'test/unit'
require 'date'
require './flight_validator_service'
require './flight_data_service'

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

  def test_data_validation
  end
end
