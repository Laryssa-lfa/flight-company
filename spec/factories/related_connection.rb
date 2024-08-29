# frozen_string_literal: true

FactoryBot.define do
  factory :related_connection do
    flight_id { :flight }
    flight_detail_id { :flight_details }
    connection_id { nil }
  end
end
