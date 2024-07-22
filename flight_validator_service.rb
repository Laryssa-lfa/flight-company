# frozen_string_literal: true

require 'date'

# Class responsible for validations
class FlightValidatorService
  attr_reader :arg

  def initialize(arg)
    @arg = arg
  end

  def self.execute(arg)
    new(arg)
  end

  def valid_airport(origin_airport = nil)
    return unless airport_validation(origin_airport)

    arg
  end

  def valid_date(departure_date = nil)
    return unless date_validation(departure_date)

    arg
  end

  private

  AIRPORTS = File.read('airports.json')

  def airport_validation(origin_airport)
    if !arg.match?(/^[a-zA-Z]{3}$/)
      puts '=> Na resposta deve conter apenas 3 letras sem caracteres especiais.'
    elsif arg.eql?(origin_airport)
      puts '=> Aeroporto de destino não pode ser o mesmo de origem.'
    elsif AIRPORTS.include?(arg.upcase)
      true
    else
      puts '=> Aeroporto não existe.'
    end
  end

  def date_validation(departure_date)
    if arg.match?(%r{^\d{2}/\d{2}/\d{4}$})
      date_parse_validation(departure_date)
    else
      puts '=> Insira uma data válida e no formato dd/mm/aaaa.'
    end
  end

  def date_parse_validation(departure_date)
    return puts '=> A data deve ser maior que o dia da partida.' if arrival_greater_departure_date?(departure_date)
    return puts '=> A data deve ser maior que hoje.' if Date.parse(arg) < Date.today

    true
  rescue StandardError
    puts '=> Insira uma data válida.'
  end

  def arrival_greater_departure_date?(departure_date)
    departure_date && Date.parse(arg) <= Date.parse(departure_date)
  end
end
