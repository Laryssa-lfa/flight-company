origin_airport = ''; destination_airport = ''; departure_time = ''; arrival_time = ''

puts '==========================================='
puts '   Projeto de Companhia Aérea - Rebase'
puts ''

while (origin_airport.empty?) do
  puts '- Qual é o aeroporto de origem?'
  origin = gets.chomp
  origin.each_char { |c| c.match?(/[0-9]/) ? (puts 'A resposta não pode conter números.'; break) : (origin_airport = origin if origin.byteslice(-1).eql?(c)) }
  puts ''
end

while (destination_airport.empty?) do
  puts '- Qual é o aeroporto de destino?'
  destination = gets.chomp
  destination.each_char { |c| c.match?(/[0-9]/) ? (puts 'A resposta não pode conter números.'; break) : (destination_airport = destination if destination.byteslice(-1).eql?(c)) }
  puts ''
end

while (departure_time.empty?) do
  puts '- Qual a data que deseja partir? [Formato: dd/mm/aaaa]'
  date = gets.chomp
  if date.match?(/[0-9]\//)
    date_time = Time.new(date.slice(6..-1), date.slice(3..4), date.slice(0..1))
    date_time > Time.now ? (departure_time = date) : (puts 'A data deve ser maior que hoje.')
  else
    puts 'Insira uma data válida no formato dd/mm/aaa.'
  end
  puts ''
end

while (arrival_time.empty?) do
  puts '- Qual será a data de retorno? [Formato: dd/mm/aaaa]'
  date = gets.chomp
  if date.match?(/[0-9]\//)
    date_time = Time.new(date.slice(6..-1), date.slice(3..4), date.slice(0..1))
    date_time > Time.now ? (arrival_time = date) : (puts 'A data deve ser maior que hoje.')
  else
    puts 'Insira uma data válida no formato dd/mm/aaa.'
  end
  puts ''
end

puts '----------------------------'
puts '   Resumo'
puts " Aeroporto de origem: #{origin_airport}"
puts " Aeroporto de destino: #{destination_airport}"
puts " Data de partida: #{departure_time}"
puts " Data de retorno: #{arrival_time.empty? ? 'sem data' : arrival_time }"
