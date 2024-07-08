require 'date'
require 'net/http'
require 'uri'

origin_airport = ''; destination_airport = ''; departure_time = ''; arrival_time = ''
arrival_response = ['S', 's', 'sim', 'Sim', 'SIM']

airports = File.read('airports.json')
file = File.read('.env').split("\n")

ENV['URL_API'] = file[0].split('=').last
ENV['HOST_API'] = file[1].split('=').last
ENV['KEY_API'] = file[2].split('=').last

puts '==========================================='
puts '   Projeto de Companhia Aérea - Rebase'

while origin_airport.empty? do
  puts "\n- Qual é o aeroporto de origem? [Formato: abreviado com 3 letras, por exemplo: GRU]"
  origin = gets.chomp
  if origin.match?(/^[a-zA-Z]{3}$/)
    airports.include?(origin.upcase) ? (origin_airport = origin) : (puts '=> Aeroporto inválido.')
  else
    puts '=> Na resposta deve conter apenas 3 letras sem caracteres especiais.'
  end
end

while destination_airport.empty? do
  puts "\n- Qual é o aeroporto de destino? [Formato: abreviado com 3 letras, por exemplo: GRU]"
  destination = gets.chomp
  case
    when !destination.match?(/^[a-zA-Z]{3}$/)
      puts '=> Na resposta deve conter apenas 3 letras sem caracteres especiais.'
    when destination.eql?(origin_airport)
      puts '=> Aeroporto de destino não pode ser o mesmo de origem.'
    when airports.include?(destination.upcase)
      destination_airport = destination
    when !destination.eql?(origin_airport)
      puts '=> Aeroporto inválido.'
  end
end

while departure_time.empty? do
  puts "\n- Qual a data que deseja partir? [Formato: dd/mm/aaaa]"
  date = gets.chomp
  if date.match?(/^\d{2}\/\d{2}\/\d{4}$/)
    begin
      Date.parse(date) >= Date.today ? (departure_time = date) : (puts '=> A data deve ser maior que hoje.')
    rescue
      puts '=> Insira uma data válida.'
    end
  else
    puts '=> Insira uma data válida e no formato dd/mm/aaaa.'
  end
end

puts "\n- Deseja informar a data de retorno? S/N"
arrival = gets.chomp

while arrival_time.empty? do
  puts "\n- Qual será a data de retorno? [Formato: dd/mm/aaaa]"
  date = gets.chomp
  if date.match?(/^\d{2}\/\d{2}\/\d{4}$/)
    begin
      Date.parse(date).strftime('%d/%m/%Y') > departure_time ? (arrival_time = date) : (puts '=> A data deve ser maior que o dia da partida.')
    rescue
      puts '=> Insira uma data válida.'
    end
  else
    puts '=> Insira uma data válida e no formato dd/mm/aaaa.'
  end
end if arrival_response.include?(arrival)

def http_request(url)
  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true

  request = Net::HTTP::Get.new(url)
  request["x-rapidapi-key"] = ENV['KEY_API']
  request["x-rapidapi-host"] = ENV['HOST_API']

  eval(http.request(request).read_body)
end

if !arrival_response.include?(arrival)
  url_one_way = URI("#{ENV['URL_API']}/search-one-way?fromEntityId=#{origin_airport.upcase}&toEntityId=#{destination_airport.upcase}&departDate=#{Date.parse(departure_time).strftime('%Y-%m-%d')}&cabinClass=economy")
  response_one_way = http_request(url_one_way)
  departure_data = response_one_way[:data][:itineraries]

  if departure_data.empty?
    puts "\n-------------------------------------"
    puts 'Temporariamente sem opções de voos!'
    puts '-------------------------------------'
  else
    puts "\n-------------------------------------------"
    puts "  Opções de Voos"
    puts "  - Saindo de #{origin_airport.upcase} para #{destination_airport.upcase} em #{departure_time}"
    puts "-------------------------------------------"

    departure_data.each_index do |index|
      puts "\n- Opção #{index+1}"
      puts "   Preço: #{departure_data[index][:price][:formatted]}"
      puts "   Quantidade de conexão: #{departure_data[index][:legs][0][:stopCount]}"
      puts "   Duração do voo: #{departure_data[index][:legs][0][:durationInMinutes]/60} horas"
      puts "   Horario de saida: #{departure_data[index][:legs][0][:departure]}"
      puts "   Horario de chegada: #{departure_data[index][:legs][0][:arrival]}"
      puts "-------\n"
    end
  end
else
  url_roundtrip = URI("#{ENV['URL_API']}/search-roundtrip?fromEntityId=#{origin_airport.upcase}&toEntityId=#{destination_airport.upcase}&departDate=#{Date.parse(departure_time).strftime('%Y-%m-%d')}&returnDate=#{Date.parse(arrival_time).strftime('%Y-%m-%d')}&cabinClass=economy")
  response_roundtrip = http_request(url_roundtrip)
  arrival_data = response_roundtrip[:data][:itineraries]

  if arrival_data.empty?
    puts "\n-------------------------------------"
    puts 'Temporariamente sem opções de voos!'
    puts '-------------------------------------'
  else
    puts "\n-------------------------------------------"
    puts "  Opções de Voos"
    puts '-------------------------------------------'

    arrival_data.each_index do |index|
      puts "\n- Opção #{index+1}"
      puts "   Preço: #{arrival_data[index][:price][:formatted]}"
      arrival_data[index][:legs].each_index do |i|
        puts " #{i.eql?(0) ? 'Voo de ida:' : 'Voo de volta:'}"
        puts "   Aeroporto de origem: #{arrival_data[index][:legs][i][:origin][:id]}"
        puts "   Aeroporto de destino: #{arrival_data[index][:legs][i][:destination][:id]}"
        puts "   Quantidade de conexão: #{arrival_data[index][:legs][i][:stopCount]}"
        puts "   Duração do voo: #{arrival_data[index][:legs][i][:durationInMinutes]/60} horas"
        puts "   Horario de saida: #{arrival_data[index][:legs][i][:departure]}"
        puts "   Horario de chegada: #{arrival_data[index][:legs][i][:arrival]}"
      end
      puts "-------\n"
    end
  end
end
