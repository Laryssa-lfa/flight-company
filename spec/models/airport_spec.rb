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
    let(:response) { Airport.request_airports }

    before do
      stub_get_request(url: "#{ENV.fetch('URL_API')}/airports", response: api_response)
    end

    context 'when external API returns airports' do
      let(:api_response) do
        {
          data: [{
            iata: 'JPA',
            name: 'Presidente Castro Pinto International Airport',
            location: 'João Pessoa'
          }]
        }
      end

      it 'returns the airports' do
        expect(response).to eql(api_response)
      end
    end

    context 'when external API does not return airports' do
      let(:api_response) { { data: [] } }

      it 'returns empty array' do
        expect(response[:data]).to eql(api_response[:data])
      end
    end
  end
end
