class SatelliteRecordController < ApplicationController
  def stats
    reporter = SatelliteReporter.new
    stats = reporter.stats
    render json: stats
  end

  def health
    reporter = SatelliteReporter.new
    health = reporter.health
    render json: health
  end

end
