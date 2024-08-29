# frozen_string_literal: true

FactoryBot.define do
  factory :flight do
    fare_category { %w[economic executive first_class].sample }
  end
end
