# frozen_string_literal: true

class Destination < ApplicationRecord
  scope :find_last_destinations, -> {
    all_destinations_two_weeks = where(created_at: start_date..end_date).pluck(:name).tally
    all_destinations_two_weeks.sort_by { |_key, value| -value }.first(5).to_h
  }

  def self.start_date
    Time.zone.parse(DateTime.current.weeks_ago(2).strftime('%d-%m-%Y'))
  end

  def self.end_date
    Time.zone.parse(DateTime.current.strftime('%d-%m-%Y')).end_of_day
  end
end
