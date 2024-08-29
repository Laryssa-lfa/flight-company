# frozen_string_literal: true

FactoryBot.define do
  factory :price do
    air_miles { nil }
    currency { 'BRL' }
    value { "#{rand(1000)},00" }
    formatted_price { "R$#{value}" }
    association :flight
  end
end
