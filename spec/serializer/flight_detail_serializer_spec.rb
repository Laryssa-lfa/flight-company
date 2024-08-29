# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FlightDetailSerializer do
  context 'builds the attributes' do
    let(:flight_detail) { FactoryBot.create(:flight_detail) }

    it 'with success' do
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
end
