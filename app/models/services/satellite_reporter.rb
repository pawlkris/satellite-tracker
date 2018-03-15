class SatelliteReporter

  def initialize
    @last_record = SatelliteRecord.last
    @average = @last_record.average
    @max = SatelliteRecord.all.max_by(&:altitude).altitude
    @min = SatelliteRecord.all.min_by(&:altitude).altitude
    @last_seven = SatelliteRecord.all.last(7)
  end

  def stats
    {average: @average, maximum: @max, minimum: @min}
  end

  def health
    if @last_record.minute_below==true
      return {message: 'WARNING: RAPID ORBITAL DECAY IMMINENT'}
    elsif @last_seven.find{|record| record.minute_below==true} && @last_seven.find{|record| record.average > 160}
      return {message: "Sustained Low Earth Orbit Resumed"}
    else
      return {message: "Altitude is A-OK"}
    end
  end

end
