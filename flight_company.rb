require 'date'

origin_airport = ''; destination_airport = ''; departure_time = ''; arrival_time = ''
response_type = ['S', 's', 'sim', 'Sim', 'SIM']

puts '==========================================='
puts '   Projeto de Companhia Aérea - Rebase'
puts ''

while (origin_airport.empty?) do
  puts '- Qual é o aeroporto de origem?'
  origin = gets.chomp
  origin.match?(/^[[:alpha:]]+$/) ? (origin_airport = origin) : (puts 'Na resposta deve conter apenas letras.')
  puts ''
end

while (destination_airport.empty?) do
  puts '- Qual é o aeroporto de destino?'
  destination = gets.chomp
  destination.match?(/^[[:alpha:]]+$/) ? (destination_airport = destination) : (puts 'Na resposta deve conter apenas.')
  puts ''
end

while (departure_time.empty?) do
  puts '- Qual a data que deseja partir? [Formato: dd/mm/aaaa]'
  date = gets.chomp
  if date.match?(/^\d{2}\/\d{2}\/\d{4}$/)
    Date.parse(date) >= Date.today ? (departure_time = date) : (puts 'A data deve ser maior que hoje.')
  else
    puts 'Insira uma data válida no formato dd/mm/aaa.'
  end
  puts ''
end

puts '- Deseja informar a data de retorno? S/N'
arrival = gets.chomp

while (arrival_time.empty?) do
  puts '- Qual será a data de retorno? [Formato: dd/mm/aaaa]'
  date = gets.chomp
  if date.match?(/^\d{2}\/\d{2}\/\d{4}$/)
    Date.parse(date) >= Date.today ? (arrival_time = date) : (puts 'A data deve ser maior que hoje.')
  else
    puts 'Insira uma data válida no formato dd/mm/aaa.'
  end
  puts ''
end if response_type.include?(arrival)

puts '----------------------------'
puts '   Resumo'
puts " Aeroporto de origem: #{origin_airport}"
puts " Aeroporto de destino: #{destination_airport}"
puts " Data de partida: #{departure_time}"
puts " Data de retorno: #{arrival_time.empty? ? 'sem data' : arrival_time }"
