# frozen_string_literal: true

class FlightsController < ApplicationController
  def search
    flights = SearchFlightService.execute(permitted_params)

    render json: flights, each_serializer: FlightSerializer
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
end
