# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Flights', type: :request do
  let(:departure_date) { 1.day.from_now }

  before do
    create(:airport)
    create(:airport, iata: 'GRU')
    create(:airport, iata: 'SSA')
  end

  context 'when flights are available' do
    let(:payload) { build_payload('JPA', 'GRU', departure_date) }
    let(:response_request) { api_response[:data][:itineraries] }
    let(:url) do
      URI(
        "#{ENV.fetch('URL_API')}/search-one-way?cabinClass=economy&departDate=" \
        "#{departure_date.strftime('%Y-%m-%d')}&fromEntityId=JPA&returnDate=&toEntityId=GRU"
      )
    end

    before do
      stub_get_request(url: url, response: api_response)
    end

    context 'and without connection' do
      let(:api_response) { load_json_symbolized('requests/one_way_flight.json') }

      it 'return flights list' do
        get '/flights/search', params: payload

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
        expect(response_body).to match(
          [
            {
              fare_category: 'economic',
              price: response_request.first[:price][:formatted],
              flight_details: [{
                origin: response_request.first.dig(:legs, 0, :origin, :name),
                destiny: response_request.first.dig(:legs, 0, :destination, :name),
                origin_airport: response_request.first.dig(:legs, 0, :origin, :displayCode),
                destination_airport: response_request.first.dig(:legs, 0, :destination, :displayCode),
                flight_number: response_request.first.dig(:legs, 0, :segments, 0, :flightNumber).to_i,
                name_airline: response_request.first.dig(:legs, 0, :segments, 0, :operatingCarrier, :name),
                departure_time: format_date(response_request.first.dig(:legs, 0, :departure)),
                arrival_time: format_date(response_request.first.dig(:legs, 0, :arrival)),
                connections: []
              }]
            },
            {
              fare_category: 'economic',
              price: response_request.last[:price][:formatted],
              flight_details: [{
                origin: response_request.last.dig(:legs, 0, :origin, :name),
                destiny: response_request.last.dig(:legs, 0, :destination, :name),
                origin_airport: response_request.last.dig(:legs, 0, :origin, :displayCode),
                destination_airport: response_request.last.dig(:legs, 0, :destination, :displayCode),
                flight_number: response_request.last.dig(:legs, 0, :segments, 0, :flightNumber).to_i,
                name_airline: response_request.last.dig(:legs, 0, :segments, 0, :operatingCarrier, :name),
                departure_time: format_date(response_request.last.dig(:legs, 0, :departure)),
                arrival_time: format_date(response_request.last.dig(:legs, 0, :arrival)),
                connections: []
              }]
            }
          ]
        )
      end
    end

    context 'and with connection' do
      let(:api_response) { load_json_symbolized('requests/one_way_with_connection.json') }

      it 'return flights list' do
        get '/flights/search', params: payload

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
        expect(response_body).to match(
          [
            {
              fare_category: 'economic',
              price: response_request.first[:price][:formatted],
              flight_details: [{
                origin: response_request.first.dig(:legs, 0, :origin, :name),
                destiny: response_request.first.dig(:legs, 0, :destination, :name),
                origin_airport: response_request.first.dig(:legs, 0, :origin, :displayCode),
                destination_airport: response_request.first.dig(:legs, 0, :destination, :displayCode),
                flight_number: response_request.first.dig(:legs, 0, :segments, 0, :flightNumber).to_i,
                name_airline: response_request.first.dig(:legs, 0, :segments, 0, :operatingCarrier, :name),
                departure_time: format_date(response_request.first.dig(:legs, 0, :departure)),
                arrival_time: format_date(response_request.first.dig(:legs, 0, :arrival)),
                connections: []
              }]
            },
            {
              fare_category: 'economic',
              price: response_request.last[:price][:formatted],
              flight_details: [{
                origin: response_request.last.dig(:legs, 0, :origin, :name),
                destiny: response_request.last.dig(:legs, 0, :destination, :name),
                origin_airport: response_request.last.dig(:legs, 0, :origin, :displayCode),
                destination_airport: response_request.last.dig(:legs, 0, :destination, :displayCode),
                flight_number: nil,
                name_airline: nil,
                departure_time: format_date(response_request.last.dig(:legs, 0, :departure)),
                arrival_time: format_date(response_request.last.dig(:legs, 0, :arrival)),
                connections: [
                  {
                    origin: response_request.last.dig(:legs, 0, :segments, 0, :origin, :name),
                    destiny: response_request.last.dig(:legs, 0, :segments, 0, :destination, :name),
                    origin_airport: response_request.last.dig(:legs, 0, :segments, 0, :origin, :displayCode),
                    destination_airport: response_request.last.dig(:legs, 0, :segments, 0, :destination, :displayCode),
                    flight_number: response_request.last.dig(:legs, 0, :segments, 0, :flightNumber).to_i,
                    name_airline: response_request.last.dig(:legs, 0, :segments, 0, :operatingCarrier, :name),
                    departure_time: format_date(response_request.last.dig(:legs, 0, :segments, 0, :departure)),
                    arrival_time: format_date(response_request.last.dig(:legs, 0, :segments, 0, :arrival))
                  },
                  {
                    origin: response_request.last.dig(:legs, 0, :segments, 1, :origin, :name),
                    destiny: response_request.last.dig(:legs, 0, :segments, 1, :destination, :name),
                    origin_airport: response_request.last.dig(:legs, 0, :segments, 1, :origin, :displayCode),
                    destination_airport: response_request.last.dig(:legs, 0, :segments, 1, :destination, :displayCode),
                    flight_number: response_request.last.dig(:legs, 0, :segments, 1, :flightNumber).to_i,
                    name_airline: response_request.last.dig(:legs, 0, :segments, 1, :operatingCarrier, :name),
                    departure_time: format_date(response_request.last.dig(:legs, 0, :segments, 1, :departure)),
                    arrival_time: format_date(response_request.last.dig(:legs, 0, :segments, 1, :arrival))
                  }
                ]
              }]
            }
          ]
        )
      end
    end
  end

  context 'when there are no flights available' do
    let(:payload) { build_payload('JPA', 'GRU', departure_date) }
    let(:api_response) { { data: { itineraries: [] }, status: true } }
    let(:url) do
      URI(
        "#{ENV.fetch('URL_API')}/search-one-way?cabinClass=economy&departDate=" \
        "#{1.day.from_now.strftime('%Y-%m-%d')}&fromEntityId=JPA&returnDate=&toEntityId=GRU"
      )
    end

    before do
      stub_get_request(url: url, response: api_response)
    end

    it 'returns a message' do
      get '/flights/search', params: payload

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include('application/json')
      expect(response_body).to match('Temporariamente sem opções de voos!')
    end
  end

  context 'when the inputs are invalid' do
    context 'when not present' do
      let(:payload) { { origin_airport: 'JPA', departure_time: departure_date.strftime('%d/%m/%Y') } }

      it 'return the message' do
        get '/flights/search', params: payload

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
        expect(response_body.first).to match('Destination airport é obrigatório!')
      end
    end

    context 'by the formation' do
      let(:payload) { build_payload('A01', 'GRU', departure_date) }

      it 'return the message' do
        get '/flights/search', params: payload

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
        expect(response_body.first).to match(
          'Origin airport é inválido! Deve conter apenas 3 letras sem caracteres especiais.'
        )
      end
    end

    context 'when airport equals' do
      let(:payload) { build_payload('GRU', 'GRU', departure_date) }

      it 'return the message' do
        get '/flights/search', params: payload

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
        expect(response_body.first).to match('Destination airport não pode ser o mesmo de origem.')
      end
    end

    context 'when airport not exist' do
      let(:payload) { build_payload('xxx', 'GRU', departure_date) }

      it 'return the message' do
        get '/flights/search', params: payload

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
        expect(response_body.first).to match('Aeroporto xxx não existe.')
      end
    end

    context 'when the date old' do
      let(:payload) { build_payload('JPA', 'GRU', -1.day.from_now) }

      it 'return the message' do
        get '/flights/search', params: payload

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
        expect(response_body.first).to match('A data deve ser maior que hoje.')
      end
    end

    context 'when arrival date is less than departure date' do
      let(:payload) do
        {
          origin_airport: 'JPA',
          destination_airport: 'GRU',
          departure_time: departure_date.strftime('%d/%m/%Y'),
          arrival_time: -2.days.from_now.to_s
        }
      end

      it 'return the message' do
        get '/flights/search', params: payload

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
        expect(response_body.first).to match('A data de chegada não pode ser menor que a data de partida.')
      end
    end
  end

  private

  def build_payload(origin_airport, destination_airport, date)
    {
      origin_airport: origin_airport.to_s,
      destination_airport: destination_airport.to_s,
      departure_time: date.strftime('%d/%m/%Y')
    }
  end

  def format_date(date)
    DateTime.parse(date).strftime('%FT%T.000Z')
  end
end
