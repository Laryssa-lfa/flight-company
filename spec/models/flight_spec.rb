# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Flight, type: :model do
  it { should have_one(:price) }
  it { should have_many(:related_connections) }
  it { should have_many(:flight_details).through(:related_connections) }

  it { should define_enum_for(:fare_category).with_default(:economic) }
end
