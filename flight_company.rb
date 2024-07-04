require 'date'

origin_airport = ''; destination_airport = ''; departure_time = ''; arrival_time = ''
response_type = ['S', 's', 'sim', 'Sim', 'SIM']
airports = File.read('airports.json')

puts '==========================================='
puts '   Projeto de Companhia Aérea - Rebase'

while origin_airport.empty? do
  puts ''
  puts '- Qual é o aeroporto de origem? [Formato: abreviado com 3 letras, por exemplo: GRU]'
  origin = gets.chomp
  if origin.match?(/^[a-zA-Z]{3}$/)
    airports.include?(origin.upcase) ? (origin_airport = origin) : (puts '=> Aeroporto inválido.')
  else
    puts '=> Na resposta deve conter apenas 3 letras sem caracteres especiais.'
  end
end

while destination_airport.empty? do
  puts ''
  puts '- Qual é o aeroporto de destino? [Formato: abreviado com 3 letras, por exemplo: GRU]'
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
  puts ''
  puts '- Qual a data que deseja partir? [Formato: dd/mm/aaaa]'
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

puts ''
puts '- Deseja informar a data de retorno? S/N'
arrival = gets.chomp

while arrival_time.empty? do
  puts ''
  puts '- Qual será a data de retorno? [Formato: dd/mm/aaaa]'
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
end if response_type.include?(arrival)

puts ''
puts '----------------------------'
puts '   Resumo'
puts " Aeroporto de origem: #{origin_airport.upcase}"
puts " Aeroporto de destino: #{destination_airport.upcase}"
puts " Data de partida: #{departure_time}"
puts " Data de retorno: #{arrival_time.empty? ? 'sem data' : arrival_time }"
