# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Flight, type: :model do
  it { is_expected.to have_one(:price) }
  it { is_expected.to delegate_method(:formatted_price).to(:price).allow_nil }
  it { is_expected.to have_many(:related_connections) }
  it { is_expected.to have_many(:flight_details).through(:related_connections) }

  it { is_expected.to define_enum_for(:fare_category).with_default(:economic) }
end
