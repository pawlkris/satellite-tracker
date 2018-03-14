class SatelliteRecordController < ApplicationController
  def stats
    average = SatelliteRecord.last.average
    max = SatelliteRecord.all.max_by(&:altitude).altitude
    min = SatelliteRecord.all.min_by(&:altitude).altitude

    render json: {average: average, maximum: max, minimum: min}
  end

  def health
    @message = SatelliteRecord.message
    render json: @message
  end

end
