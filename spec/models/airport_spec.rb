# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Airport, type: :model do
  describe 'scope by_iata' do
    context 'when there airports' do
      let(:airport) { create(:airport) }
      let(:response) { Airport.by_iata(airport.iata) }

      it 'returns the airport' do
        expect(response.to_json).to eql([airport].to_json)
      end
    end

    context 'when there no airports' do
      let(:airport) { Airport.new }
      let(:response) { Airport.by_iata(airport.iata) }

      it 'returns empty array' do
        expect(response.to_json).to eql([].to_json)
      end
    end

    context 'when the airport does not exist' do
      let(:response) { Airport.by_iata('xxx') }

      it 'returns empty array' do
        expect(response.to_json).to eql([].to_json)
      end
    end
  end

  describe '#prepare_db_for_airports' do
    context 'when exist airports in the db' do
      let!(:airports) { create(:airport) }
      let(:response) { Airport.new.prepare_db_for_airports }

      it 'returns nil' do
        expect(response).to be_nil
      end
    end

    context 'when there are no airports in the db' do
      let(:api_response) { build(:airport) }
      let(:response) { Airport.new.prepare_db_for_airports }

      before do
        stub_get_request(url: "#{ENV.fetch('URL_API')}/airports", response: [api_response])
      end

      it 'search the airports in API' do
        expect(response.to_json).to eql([api_response].to_json)
      end
    end
  end
end
