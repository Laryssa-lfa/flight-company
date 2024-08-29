# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Flights', type: :request do
  let(:payload) { build_payload('JPA', 'GRU', date_current) }
  let(:flight) { FactoryBot.create_list(:flight, 2) }
  let(:flight_detail) { FactoryBot.create_list(:flight_detail, 2) }

  before do
    0..2.times do |index|
      FactoryBot.create(:price, flight_id: flight[index].id)
      FactoryBot.create(
        :related_connection,
        flight_id: flight[index].id,
        flight_detail_id: flight_detail[index].id
      )
    end

    FactoryBot.create(:airport)
    FactoryBot.create(
      :airport,
      iata: 'GRU',
      name: 'São Paulo/Guarulhos–Governador André Franco Montoro International Airport',
      location: 'São Paulo'
    )
  end

  context 'when flights are available' do
    it 'return flights list' do
      allow(SearchFlightService).to receive(:execute).and_return(flight)

      get '/flights/search', params: payload

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include('application/json')
      expect(response_body).to eq([
        {
          fare_category: flight[0].fare_category,
          price: flight[0].price.formatted_price,
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
          fare_category: flight[1].fare_category,
          price: flight[1].price.formatted_price,
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
      ])
    end
  end

  context 'when there are no flights available' do
    it 'returns a message' do
      allow(SearchFlightService)
        .to receive(:execute)
        .and_return('Temporariamente sem opções de voos!'.to_json)

      get '/flights/search', params: payload

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include('application/json')
      expect(response_body).to eq('Temporariamente sem opções de voos!')
    end
  end

  context 'when the inputs are invalid' do
    context 'when not present' do
      let(:payload) { {'origin_airport': 'JPA', 'departure_time': "#{date_current}"} }

      it 'return the message' do
        get '/flights/search', params: payload

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
        expect(response_body).to eq('Atributo `destination_airport` é obrigatório!')
      end
    end

    context 'by the formation' do
      let(:payload) { build_payload('A01', 'GRU', date_current) }

      it 'return the message' do
        get '/flights/search', params: payload

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
        expect(response_body).to eq(
          'Formato de `origin_airport` é inválido! Deve conter apenas 3 letras sem caracteres especiais.'
        )
      end
    end

    context 'when airport equals' do
      let(:payload) { build_payload('GRU', 'GRU', date_current) }

      it 'return the message' do
        get '/flights/search', params: payload

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
        expect(response_body).to eq('Aeroporto de destino não pode ser o mesmo de origem.')
      end
    end

    context 'when airport not exist' do
      let(:payload) { build_payload('xxx', 'GRU', date_current) }

      it 'return the message' do
        get '/flights/search', params: payload

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
        expect(response_body).to eq('Aeroporto `xxx` não existe.')
      end
    end

    context 'when the date old' do
      let(:payload) { build_payload('JPA', 'GRU', date_current - 1) }

      it 'return the message' do
        get '/flights/search', params: payload

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
        expect(response_body).to eq('A data deve ser maior que hoje.')
      end
    end

    context 'when arrival date is less than departure date' do
      let(:payload) do
        {
          'origin_airport': 'JPA',
          'destination_airport': 'GRU',
          'departure_time': "#{date_current}",
          'arrival_time': "#{date_current - 2}"
        }
      end

      it 'return the message' do
        get '/flights/search', params: payload

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
        expect(response_body).to eq('A data de chegada não pode ser menor que a data de partida.')
      end
    end
  end

  private

  def build_payload(origin_airport, destination_airport, date)
    {
      'origin_airport': "#{origin_airport}",
      'destination_airport': "#{destination_airport}",
      'departure_time': "#{date.strftime('%d/%m/%Y')}"
    }
  end

  def date_current
    DateTime.current
  end
end
