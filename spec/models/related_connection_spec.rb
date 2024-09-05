# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RelatedConnection, type: :model do
  it { is_expected.to belong_to(:flight) }
  it { is_expected.to belong_to(:flight_detail) }
end
