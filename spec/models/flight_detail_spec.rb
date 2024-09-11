# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FlightDetail, type: :model do
  it { is_expected.to have_many(:related_connections) }
  it { is_expected.to have_many(:flights).through(:related_connections) }

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

      it 'returns the error message' do
        expect(flight_detail).to be_invalid
        expect(flight_detail.errors.full_messages[0..2]).to eql(
          [
            'Origin airport é obrigatório!',
            'Destination airport é obrigatório!',
            'Departure time é obrigatório!'
          ]
        )
      end
    end

    context 'when origin_airport and destination_airport are equal' do
      let(:flight_detail) { build_class('JPA', 'JPA', 1.day.from_now) }

      it 'returns the error message' do
        expect(flight_detail).to be_invalid
        expect(flight_detail.errors.full_messages)
          .to eql(['Destination airport não pode ser o mesmo de origem.'])
      end
    end

    context 'when origin_airport has invalid format' do
      let(:flight_detail) { build_class('J01', 'JPA', 1.day.from_now) }

      it 'returns the error message' do
        expect(flight_detail).to be_invalid
        expect(flight_detail.errors.full_messages).to eql(
          [
            'Origin airport é inválido! Deve conter apenas 3 letras sem caracteres especiais.',
            'Aeroporto J01 não existe.'
          ]
        )
      end
    end

    context 'when departure_time is less than today' do
      let(:flight_detail) { build_class('JPA', 'GRU', -1.day.from_now) }

      it 'returns the error message' do
        expect(flight_detail).to be_invalid
        expect(flight_detail.errors.full_messages).to eql(['A data deve ser maior que hoje.'])
      end
    end

    context 'when arrival_time is less than departure_time' do
      let(:flight_detail) { build_class('JPA', 'GRU', 1.day.from_now, -1.day.from_now) }

      it 'returns the error message' do
        expect(flight_detail).to be_invalid
        expect(flight_detail.errors.full_messages)
          .to eql(['A data de chegada não pode ser menor que a data de partida.'])
      end
    end

    context 'when airport does not exist' do
      let(:flight_detail) { build_class('JPA', 'XXX', 1.day.from_now) }

      it 'returns the error message' do
        expect(flight_detail).to be_invalid
        expect(flight_detail.errors.full_messages).to eql(['Aeroporto XXX não existe.'])
      end
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

      it 'returns be nil' do
        expect(response.first).to be_nil
      end
    end

    context 'when there connections' do
      let(:connection) { create(:flight_detail, destination_airport: 'MVD') }
      let(:connection_id) { connection.id }
      let(:response) { FlightDetail.find_connections(flight_detail) }

      it 'returns connections' do
        expect(response.first).to eql(connection)
      end
    end
  end

  describe 'scope find_flight_details' do
    context 'when there flights details' do
      let(:flight_detail) { create(:flight_detail) }
      let(:response) do
        FlightDetail.find_flight_details(
          flight_detail.origin_airport,
          flight_detail.destination_airport,
          flight_detail.departure_time.strftime('%d-%m-%Y')
        )
      end

      it 'returns the flights details' do
        expect(response.first).to eql(flight_detail)
      end
    end

    context 'when there no flights details' do
      let(:flight_detail) { build(:flight_detail) }
      let(:response) do
        FlightDetail.find_flight_details(
          flight_detail.origin_airport,
          flight_detail.destination_airport,
          flight_detail.departure_time.strftime('%d-%m-%Y')
        )
      end

      it 'returns connections' do
        expect(response.first).to be_nil
      end
    end
  end

  private

  def build_class(origin_airport, destination_airport, departure_time, arrival_time = nil)
    described_class.new(
      origin_airport: origin_airport,
      destination_airport: destination_airport,
      departure_time: departure_time,
      arrival_time: arrival_time
    )
  end
end
