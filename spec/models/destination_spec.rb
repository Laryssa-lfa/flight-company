# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Destination, type: :model do
  describe 'scope find_last_destinations' do
    context 'when there is flight searched' do
      let(:response) { Destination.find_last_destinations }

      before do
        Destination.create(name: 'SSA')
        %w[GRU SSA REC CNF BSB GIG MVD].each do |airport|
          Destination.create(name: airport)
        end
        4.times do
          Destination.create(name: 'GRU')
        end
      end

      it 'returns the most searched destinations' do
        expect(response).to match({ 'GRU' => 5, 'SSA' => 2, 'CNF' => 1, 'GIG' => 1, 'BSB' => 1 })
      end
    end

    context 'when there is no flight searched' do
      let(:response) { Destination.find_last_destinations }

      it 'returns be nil' do
        expect(response.first).to be_nil
      end
    end
  end
end
