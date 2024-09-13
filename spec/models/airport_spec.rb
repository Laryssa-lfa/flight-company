# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Airport, type: :model do
  describe 'scope by_iata' do
    context 'when there airports' do
      let(:airport) { create(:airport) }
      let(:response) { Airport.by_iata(airport.iata) }

      it 'returns the airport' do
        expect(response.first).to eql(airport)
      end
    end

    context 'when there no airports' do
      let(:airport) { Airport.new }
      let(:response) { Airport.by_iata(airport.iata) }

      it 'returns nil' do
        expect(response.first).to be_nil
      end
    end

    context 'when the airport does not exist' do
      let!(:airport) { create(:airport) }
      let(:response) { Airport.by_iata('xxx') }

      it 'returns nil' do
        expect(response.first).to be_nil
      end
    end
  end

  describe '.request_airports' do
    let(:response) { Airport.request_airports[:data] }
    let(:airports) { load_json_symbolized('airportss.json')[:data] }

    it 'returns the airports' do
      expect(response.count).to eql(airports.count)
    end
  end
end
