class FlightDetail < ApplicationRecord
  belongs_to :connections, class_name: "FlightDetail", optional: true
end
