# frozen_string_literal: true

class FlightDetail < ApplicationRecord
  has_many :related_connections, dependent: nil
  has_many :flights, through: :related_connections

  validates :origin_airport, :destination_airport, :departure_time, presence: true
  validates :destination_airport, comparison: { other_than: :origin_airport }
  validates :origin_airport, :destination_airport, format: {
    with: /\A[a-zA-Z]{3}\z/, message: I18n.t('activerecord.errors.models.flight_detail.format')
  }
  validate :less_than_today, if: :departure_time
  validate :less_than_departure, if: :arrival_time
  validate :airport_exist

  scope :find_connections, ->(obj) {
    connection_ids = obj.related_connections.pluck(:connection_id).compact
    where(id: connection_ids)
  }

  private

  def less_than_today
    return unless Date.parse(departure_time) < Time.zone.today

    errors.add(:base, I18n.t('activerecord.errors.models.flight_detail.today'))
  end

  def less_than_departure
    return unless Date.parse(arrival_time) < Date.parse(departure_time)

    errors.add(:base, I18n.t('activerecord.errors.models.flight_detail.less_than'))
  end

  def airport_exist
    Airport.new.prepare_db_for_airports
    return message_error_airport(origin_airport) unless origin_airport.present? && exist_airport?(origin_airport)
    return if destination_airport.present? && exist_airport?(destination_airport)

    message_error_airport(destination_airport)
  end

  def exist_airport?(airport)
    Airport.by_iata(airport).present?
  end

  def message_error_airport(airport)
    errors.add(:base, I18n.t('activerecord.errors.models.flight_detail.airport', airport: airport))
  end
end
