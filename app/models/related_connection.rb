class RelatedConnection < ApplicationRecord
  belongs_to :flight_detail
  belongs_to :flight
end
