# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Price, type: :model do
  it { should belong_to(:flight) }
end
