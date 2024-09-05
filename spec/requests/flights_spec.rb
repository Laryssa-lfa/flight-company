# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Flights', type: :request do
  let(:departure_date) { 1.day.from_now }

  before do
    create(:airport)
    create(:airport, iata: 'GRU')
  end

  context 'when flights are available' do
    let(:payload) { build_payload('JPA', 'GRU', departure_date) }
    let(:flights) { create_list(:flight, 2) }
    let(:flight_detail) do
      create_list(
        :flight_detail, 2,
        departure_time: departure_date.strftime('%d/%m/%Y - %H:%M:%S')
      )
    end

    before do
      0..(2.times do |index|
        create(:price, flight_id: flights[index].id)
        create(
          :related_connection,
          flight_id: flights[index].id,
          flight_detail_id: flight_detail[index].id
        )
      end)
    end

    it 'return flights list' do
      get '/flights/search', params: payload

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include('application/json')
      expect(response_body).to eq(
        [
          {
            fare_category: flights[0].fare_category,
            price: flights[0].price.formatted_price,
            flight_details: [{
              origin: flight_detail[0].origin,
              destiny: flight_detail[0].destiny,
              origin_airport: flight_detail[0].origin_airport,
              destination_airport: flight_detail[0].destination_airport,
              flight_number: flight_detail[0].flight_number,
              name_airline: flight_detail[0].name_airline,
              departure_time: flight_detail[0].departure_time,
              arrival_time: flight_detail[0].arrival_time,
              connections: []
            }]
          },
          {
            fare_category: flights[1].fare_category,
            price: flights[1].price.formatted_price,
            flight_details: [{
              origin: flight_detail[1].origin,
              destiny: flight_detail[1].destiny,
              origin_airport: flight_detail[1].origin_airport,
              destination_airport: flight_detail[1].destination_airport,
              flight_number: flight_detail[1].flight_number,
              name_airline: flight_detail[1].name_airline,
              departure_time: flight_detail[1].departure_time,
              arrival_time: flight_detail[1].arrival_time,
              connections: []
            }]
          }
        ]
      )
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
      expect(response_body).to eq('Temporariamente sem opções de voos!')
    end
  end

  context 'when the inputs are invalid' do
    context 'when not present' do
      let(:payload) { { origin_airport: 'JPA', departure_time: departure_date.strftime('%d/%m/%Y') } }

      it 'return the message' do
        get '/flights/search', params: payload

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
        expect(response_body.first).to eq('Destination airport é obrigatório!')
      end
    end

    context 'by the formation' do
      let(:payload) { build_payload('A01', 'GRU', departure_date) }

      it 'return the message' do
        get '/flights/search', params: payload

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
        expect(response_body.first).to eq(
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
        expect(response_body.first).to eq('Destination airport não pode ser o mesmo de origem.')
      end
    end

    context 'when airport not exist' do
      let(:payload) { build_payload('xxx', 'GRU', departure_date) }

      it 'return the message' do
        get '/flights/search', params: payload

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
        expect(response_body.first).to eq('Aeroporto xxx não existe.')
      end
    end

    context 'when the date old' do
      let(:payload) { build_payload('JPA', 'GRU', -1.day.from_now) }

      it 'return the message' do
        get '/flights/search', params: payload

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
        expect(response_body.first).to eq('A data deve ser maior que hoje.')
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
        expect(response_body.first).to eq('A data de chegada não pode ser menor que a data de partida.')
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
end
