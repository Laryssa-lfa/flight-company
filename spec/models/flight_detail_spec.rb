# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FlightDetail, type: :model do
  it { should have_many(:related_connections) }
  it { should have_many(:flights).through(:related_connections) }
end
