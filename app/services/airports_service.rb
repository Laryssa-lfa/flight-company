# frozen_string_literal: true

class AirportsService
  def initialize(airport)
    @airport = airport
  end

  def self.exist_airport(airport)
    new(airport).airports
  end

  def airports
    find_or_create_airport
  end

  private

  attr_reader :airport

  def find_or_create_airport
    save_airports if Airport.count.zero?
    true if Airport.find_by(iata: airport)
  end

  def save_airports
    all_airports.each do |obj|
      Airport.find_or_create_by!(
        iata: obj[:iata],
        name: obj[:name],
        location: obj[:location]
      )
    end
  end

  def all_airports
    # RequestHttpService.request("#{ENV.fetch('URL_API')}/airports")
    JSON.parse(File.read('./airports.json'), symbolize_names: true)
  end
end
