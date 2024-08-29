# frozen_string_literal: true

class FlightsController < ApplicationController
  before_action :validate_data

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

  def validate_data
    validate = ParamsValidateService.execute(permitted_params)
    render json: validate.to_json if validate != true
  end
end
