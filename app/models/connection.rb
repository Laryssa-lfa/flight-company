class Connection < ApplicationRecord
  belongs_to :flight
  belongs_to :flight_detail
end
