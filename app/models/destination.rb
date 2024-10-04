# frozen_string_literal: true

class Destination < ApplicationRecord
  scope :find_last_destinations, -> {
    where(created_at: 2.weeks.ago.beginning_of_day..Time.current.end_of_day)
      .group(:name).order('count_name desc').limit(5).count(:name)
  }
end
