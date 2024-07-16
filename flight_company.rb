# frozen_string_literal: true

require 'date'
require 'net/http'
require 'uri'
require 'json'

ARRIVAL_RESPONSE = %w[S s sim Sim SIM].freeze
AIRPORTS = File.read('airports.json')

origin_airport = ''
destination_airport = ''
departure_time = ''
arrival_time = ''

file_envs = File.read('.env').split(%r{=|\n})
ENV = Hash[*file_envs]

puts '==========================================='
puts '   Projeto de Companhia Aérea - Rebase'

while origin_airport.empty?
  puts "\n- Qual é o aeroporto de origem? [Formato: abreviado com 3 letras, por exemplo: GRU]"
  origin = gets.chomp
  if origin.match?(/^[a-zA-Z]{3}$/)
    AIRPORTS.include?(origin.upcase) ? (origin_airport = origin) : (puts '=> Aeroporto inválido.')
  else
    puts '=> Na resposta deve conter apenas 3 letras sem caracteres especiais.'
  end
end

while destination_airport.empty?
  puts "\n- Qual é o aeroporto de destino? [Formato: abreviado com 3 letras, por exemplo: GRU]"
  destination = gets.chomp
  if !destination.match?(/^[a-zA-Z]{3}$/)
    puts '=> Na resposta deve conter apenas 3 letras sem caracteres especiais.'
  elsif destination.eql?(origin_airport)
    puts '=> Aeroporto de destino não pode ser o mesmo de origem.'
  elsif AIRPORTS.include?(destination.upcase)
    destination_airport = destination
  else
    puts '=> Aeroporto inválido.'
  end
end

while departure_time.empty?
  puts "\n- Qual a data que deseja partir? [Formato: dd/mm/aaaa]"
  date = gets.chomp
  if date.match?(%r{^\d{2}/\d{2}/\d{4}$})
    begin
      Date.parse(date) >= Date.today ? (departure_time = date) : (puts '=> A data deve ser maior que hoje.')
    rescue StandardError
      puts '=> Insira uma data válida.'
    end
  else
    puts '=> Insira uma data válida e no formato dd/mm/aaaa.'
  end
end

puts "\n- Deseja informar a data de retorno? S/N"
arrival = gets.chomp

def date_validation(date, departure_time)
  return puts '=> A data deve ser maior que o dia da partida.' unless Date.parse(date) > Date.parse(departure_time)

  date
rescue StandardError
  puts '=> Insira uma data válida.'
end

if ARRIVAL_RESPONSE.include?(arrival)
  while arrival_time.empty?
    puts "\n- Qual será a data de retorno? [Formato: dd/mm/aaaa]"
    date = gets.chomp
    if date.match?(%r{^\d{2}/\d{2}/\d{4}$})
      arrival_time = date_validation(date, departure_time).to_s
    else
      puts '=> Insira uma data válida e no formato dd/mm/aaaa.'
    end
  end
end

def http_request(url)
  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true

  request = Net::HTTP::Get.new(url)
  request['x-rapidapi-key'] = ENV.fetch('KEY_API')
  request['x-rapidapi-host'] = ENV.fetch('HOST_API')

  result = http.request(request).read_body
  JSON.parse(result, symbolize_names: true)
end

if ARRIVAL_RESPONSE.include?(arrival)
  url_roundtrip = URI("#{ENV.fetch('URL_API')}/search-roundtrip?fromEntityId=#{origin_airport.upcase}\
&toEntityId=#{destination_airport.upcase}&departDate=#{Date.parse(departure_time).strftime('%Y-%m-%d')}\
&returnDate=#{Date.parse(arrival_time).strftime('%Y-%m-%d')}&cabinClass=economy")

  response_roundtrip = http_request(url_roundtrip)
  arrival_data = response_roundtrip[:data][:itineraries]

  if !response_roundtrip[:status] || arrival_data.empty?
    puts "\n-------------------------------------"
    puts 'Temporariamente sem opções de voos!'
    puts '-------------------------------------'
  else
    puts "\n-------------------------------------------"
    puts '  Opções de Voos'
    puts '-------------------------------------------'

    arrival_data.each_index do |index|
      puts "\n- Opção #{index + 1}"
      puts "   Preço: #{arrival_data[index][:price][:formatted]}"
      arrival_data[index][:legs].each_index do |i|
        puts " #{i.eql?(0) ? 'Voo de ida:' : 'Voo de volta:'}"
        puts "   Aeroporto de origem: #{arrival_data[index][:legs][i][:origin][:id]}"
        puts "   Aeroporto de destino: #{arrival_data[index][:legs][i][:destination][:id]}"
        puts "   Quantidade de conexão: #{arrival_data[index][:legs][i][:stopCount]}"
        puts "   Duração do voo: #{arrival_data[index][:legs][i][:durationInMinutes] / 60} horas"
        puts "   Horario de saida: #{arrival_data[index][:legs][i][:departure]}"
        puts "   Horario de chegada: #{arrival_data[index][:legs][i][:arrival]}"
      end
      puts "-------\n"
    end
  end
else
  url_one_way = URI("#{ENV.fetch('URL_API')}/search-one-way?fromEntityId=#{origin_airport.upcase}\
&toEntityId=#{destination_airport.upcase}&departDate=#{Date.parse(departure_time).strftime('%Y-%m-%d')}\
&cabinClass=economy")

  response_one_way = http_request(url_one_way)
  departure_data = response_one_way[:data][:itineraries]

  if !response_one_way[:status] || departure_data.empty?
    puts "\n-------------------------------------"
    puts 'Temporariamente sem opções de voos!'
    puts '-------------------------------------'
  else
    puts "\n-------------------------------------------"
    puts '  Opções de Voos'
    puts "  - Saindo de #{origin_airport.upcase} para #{destination_airport.upcase} em #{departure_time}"
    puts '-------------------------------------------'

    departure_data.each_index do |index|
      puts "\n- Opção #{index + 1}"
      puts "   Preço: #{departure_data[index][:price][:formatted]}"
      puts "   Quantidade de conexão: #{departure_data[index][:legs][0][:stopCount]}"
      puts "   Duração do voo: #{departure_data[index][:legs][0][:durationInMinutes] / 60} horas"
      puts "   Horario de saida: #{departure_data[index][:legs][0][:departure]}"
      puts "   Horario de chegada: #{departure_data[index][:legs][0][:arrival]}"
      puts "-------\n"
    end
  end
end
