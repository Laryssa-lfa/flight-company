# frozen_string_literal: true

FactoryBot.define do
  factory :airport do
    iata { 'JPA' }
    name { 'Presidente Castro Pinto International Airport' }
    location { 'João Pessoa' }
  end
end
