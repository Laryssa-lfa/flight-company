# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RelatedConnection, type: :model do
  it { should belong_to(:flight) }
  it { should belong_to(:flight_detail) }
end
