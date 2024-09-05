# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FlightDetailSerializer do
  context 'builds the attributes' do
    let(:flight_detail) { create(:flight_detail) }
    let(:connection_id) { nil }

    before do
      create(:airport)
      create(:airport, iata: 'GRU')
      create(
        :related_connection,
        flight_id: create(:flight).id,
        flight_detail_id: flight_detail.id,
        connection_id: connection_id
      )
    end

    context 'without connections' do
      it 'build with success' do
        response = FlightDetailSerializer.new(flight_detail).serializable_hash

        expect(response).to eq({
          origin: flight_detail.origin,
          destiny: flight_detail.destiny,
          origin_airport: flight_detail.origin_airport,
          destination_airport: flight_detail.destination_airport,
          flight_number: flight_detail.flight_number,
          name_airline: flight_detail.name_airline,
          departure_time: flight_detail.departure_time,
          arrival_time: flight_detail.arrival_time,
          connections: []
        })
      end
    end

    context 'with connections' do
      let(:connection) { create(:flight_detail) }
      let(:connection_id) { connection.id }

      it 'build with success' do
        response = FlightDetailSerializer.new(flight_detail).serializable_hash

        expect(response).to eq({
          origin: flight_detail.origin,
          destiny: flight_detail.destiny,
          origin_airport: flight_detail.origin_airport,
          destination_airport: flight_detail.destination_airport,
          flight_number: flight_detail.flight_number,
          name_airline: flight_detail.name_airline,
          departure_time: flight_detail.departure_time,
          arrival_time: flight_detail.arrival_time,
          connections: [
            origin: connection.origin,
            destiny: connection.destiny,
            origin_airport: connection.origin_airport,
            destination_airport: connection.destination_airport,
            flight_number: connection.flight_number,
            name_airline: connection.name_airline,
            departure_time: connection.departure_time,
            arrival_time: connection.arrival_time
          ]
        })
      end
    end
  end
end
