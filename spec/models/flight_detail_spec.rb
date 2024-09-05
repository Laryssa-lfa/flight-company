# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FlightDetail, type: :model do
  it { should have_many(:related_connections) }
  it { should have_many(:flights).through(:related_connections) }

  before do
    create(:airport)
    create(:airport, iata: 'GRU')
    create(:airport, iata: 'MVD')
  end

  describe 'validations' do
    context 'with all valid data' do
      let(:flight_detail) { build(:flight_detail) }
      it { expect(flight_detail).to be_valid }
    end

    context 'with all invalid data' do
      let(:flight_detail) { described_class.new }
      it { expect(flight_detail).to be_invalid }
    end

    context 'when origin_airport and destination_airport are equal' do
      let(:flight_detail) { build(:flight_detail, origin_airport: 'JPA', destination_airport: 'JPA') }
      it { expect(flight_detail).to be_invalid }
    end

    context 'when origin_airport has invalid format' do
      let(:flight_detail) { build(:flight_detail, origin_airport: 'J01') }
      it { expect(flight_detail).to be_invalid }
    end

    context 'when departure_time is less than today' do
      let(:flight_detail) { build(:flight_detail, departure_time: -1.day.from_now) }
      it { expect(flight_detail).to be_invalid }
    end

    context 'when arrival_time is less than departure_time' do
      let(:flight_detail) { build(:flight_detail, departure_time: 1.day.from_now, arrival_time: -1.day.from_now) }
      it { expect(flight_detail).to be_invalid }
    end

    context 'when airport does not exist' do
      let(:flight_detail) { build(:flight_detail, origin_airport: 'xxx') }
      it { expect(flight_detail).to be_invalid }
    end
  end

  describe 'scope find_connections' do
    let(:flight_detail) { create(:flight_detail) }
    let(:connection_id) { nil }

    before do
      create(
        :related_connection,
        flight_id: create(:flight).id,
        flight_detail_id: flight_detail.id,
        connection_id: connection_id
      )
    end

    context 'when there are no connections' do
      let(:response) { FlightDetail.find_connections(flight_detail) }

      it 'returns empty array' do
        expect(response.to_json).to eql([].to_json)
      end
    end

    context 'when there connections' do
      let(:connection) { create(:flight_detail, destination_airport: 'MVD') }
      let(:connection_id) { connection.id }
      let(:response) { FlightDetail.find_connections(flight_detail) }

      it 'returns connections' do
        expect(response.to_json).to eql([connection].to_json)
      end
    end
  end
end
