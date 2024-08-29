# frozen_string_literal: true

class ParamsValidateService
  def initialize(arg)
    @arg = arg
  end

  def self.execute(arg)
    new(arg).params_validates
  end

  def params_validates
    valid_data
  end

  private

  attr_reader :arg

  MESSAGE_ERROR = {
    airport: 'Aeroporto de destino não pode ser o mesmo de origem.',
    today: 'A data deve ser maior que hoje.',
    less_than: 'A data de chegada não pode ser menor que a data de partida.'
  }.freeze

  def valid_data
    return origin_airport_valid unless origin_airport_valid.nil?
    return destination_airport_valid unless destination_airport_valid.nil?
    return dates_valid unless dates_valid.nil?

    true
  end

  def origin_airport_valid
    return message_error_present('origin_airport') if origin_airport.blank?
    return message_error_format('origin_airport') unless origin_airport.match?(/\A[a-zA-Z]{3}\z/)

    message_error_not_exist(origin_airport) unless exist_airport(origin_airport)
  end

  def destination_airport_valid
    return message_error_present('destination_airport') if destination_airport.blank?
    return message_error_format('destination_airport') unless destination_airport.match?(/\A[a-zA-Z]{3}\z/)
    return MESSAGE_ERROR[:airport] if origin_airport.eql?(destination_airport)

    message_error_not_exist(destination_airport) unless exist_airport(destination_airport)
  end

  def dates_valid
    return message_error_present('departure_time') if departure_date.blank?
    return MESSAGE_ERROR[:today] if Date.parse(departure_date) < Time.zone.today

    arrival_date_valid if arrival_date.present?
  end

  def arrival_date_valid
    MESSAGE_ERROR[:less_than] if Date.parse(arrival_date) < Date.parse(departure_date)
  end

  def exist_airport(airport)
    AirportsService.exist_airport(airport)
  end

  def message_error_present(airport)
    "Atributo `#{airport}` é obrigatório!"
  end

  def message_error_not_exist(airport)
    "Aeroporto `#{airport}` não existe."
  end

  def message_error_format(airport)
    "Formato de `#{airport}` é inválido! Deve conter apenas 3 letras sem caracteres especiais."
  end

  def origin_airport
    arg[:origin_airport]
  end

  def destination_airport
    arg[:destination_airport]
  end

  def departure_date
    arg[:departure_time]
  end

  def arrival_date
    arg[:arrival_time]
  end
end
