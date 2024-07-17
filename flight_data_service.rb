# frozen_string_literal: true

require './file_env'
require './http_service'

# Class responsible for the return of data
class FlightDataService
  attr_reader :arg

  def initialize(arg)
    @arg = arg
  end

  def self.execute(arg)
    new(arg)
  end

  def flight_itineraries
    return itineraries_one_way if arg[:arrival_time].nil?

    itineraries_roundtrip
  end

  private

  ENV = FileEnv.execute

  def itineraries_one_way
    url = "#{ENV.fetch('URL_API')}/search-one-way?fromEntityId=#{arg[:origin_airport].upcase}\
&toEntityId=#{arg[:destination_airport].upcase}&departDate=#{Date.parse(arg[:departure_time]).strftime('%Y-%m-%d')}\
&cabinClass=economy"
    response_flights(url)
  end

  def itineraries_roundtrip
    url = "#{ENV.fetch('URL_API')}/search-roundtrip?fromEntityId=#{arg[:origin_airport].upcase}\
&toEntityId=#{arg[:destination_airport].upcase}&departDate=#{Date.parse(arg[:departure_time]).strftime('%Y-%m-%d')}\
&returnDate=#{Date.parse(arg[:arrival_time]).strftime('%Y-%m-%d')}&cabinClass=economy"
    response_flights(url)
  end

  def response_flights(url)
    response = HttpService.request(url)
    return without_flight if !response[:status] || response[:data][:itineraries].empty?

    flights_summary(response[:data][:itineraries])
  end

  def flights_summary(flights)
    puts "\n------------------\n  Opções de Voos\n------------------"

    flights.each_index do |index|
      puts "\n- Opção #{index + 1} -- Preço: #{flights[index][:price][:formatted]}"
      flight_itinerary(flights[index])
      puts "-------\n"
    end
  end

  def flight_itinerary(obj)
    obj[:legs].each_index do |i|
      roundtrip(obj[:legs], i)
      flight_data(obj[:legs][i])
    end
  end

  def roundtrip(obj, index)
    return unless obj.length.eql?(2)

    puts " #{index.eql?(0) ? 'Voo de ida:' : 'Voo de volta:'}"
    puts "   Aeroporto de origem: #{obj[index][:origin][:id]}"
    puts "   Aeroporto de destino: #{obj[index][:destination][:id]}"
  end

  def flight_data(obj)
    puts "   Quantidade de conexão: #{obj[:stopCount]}"
    puts "   Duração do voo: #{obj[:durationInMinutes] / 60} horas"
    puts "   Horario de saida: #{obj[:departure]}"
    puts "   Horario de chegada: #{obj[:arrival]}"
  end

  def without_flight
    puts "\n---------------------------------------"
    puts '  Temporariamente sem opções de voos!'
    puts '---------------------------------------'
  end
end
