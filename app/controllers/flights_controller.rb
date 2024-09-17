# frozen_string_literal: true

class FlightsController < ApplicationController
  before_action :saved_searched_destinations, only: :search

  def search
    flights = SearchFlightService.execute(permitted_params)

    render json: flights, each_serializer: FlightSerializer
  end

  def search_destinations
    render json: Destination.find_last_destinations.to_json
  end

  private

  def permitted_params
    params.permit(
      :origin_airport,
      :destination_airport,
      :departure_time,
      :arrival_time,
      :fare_category
    )
  end

  def saved_searched_destinations
    Destination.create(name: permitted_params[:destination_airport])
  end
end
