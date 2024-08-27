# frozen_string_literal: true

class Flight < ApplicationRecord
  enum :fare_category, { economic: 0, executive: 1, first_class: 2 }, default: :economic
end
