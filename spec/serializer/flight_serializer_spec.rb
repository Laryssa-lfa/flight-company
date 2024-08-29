# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FlightSerializer do
  context 'builds the attributes' do
    let(:flight) { FactoryBot.create(:flight) }
    let(:response) { FlightSerializer.new(flight).serializable_hash }

    it 'with success the flight' do
      expect(response).to eq({
        fare_category: flight.fare_category,
        price: nil,
        flight_details: []
      })
    end

    context 'when have price associate' do
      let!(:price) { FactoryBot.create(:price, flight_id: flight.id) }

      it 'build with success' do
        expect(response).to eq({
          fare_category: flight.fare_category,
          price: flight.price.formatted_price,
          flight_details: []
        })
      end
    end

    context 'when have flight_details' do
      let(:flight_detail) { FactoryBot.create(:flight_detail) }
      let!(:price) { FactoryBot.create(:price, flight_id: flight.id) }

      before do
        FactoryBot.create(
          :related_connection,
          flight_id: flight.id,
          flight_detail_id: flight_detail.id
        )
      end

      it 'build with success' do
        expect(response).to eq({
          fare_category: flight.fare_category,
          price: flight.price.formatted_price,
          flight_details: [{
            origin: flight_detail.origin,
            destiny: flight_detail.destiny,
            origin_airport: flight_detail.origin_airport,
            destination_airport: flight_detail.destination_airport,
            flight_number: flight_detail.flight_number,
            name_airline: flight_detail.name_airline,
            departure_time: flight_detail.departure_time,
            arrival_time: flight_detail.arrival_time,
            connections: []
          }]
        })
      end
    end
  end
end
