class SatelliteDataFetcher

  API_URL = "nestio.space/api/satellite/data"
  HEADERS = {Accept:'application/json'}

  def self.fetch
    response = JSON.parse(RestClient.get(API_URL, HEADERS))
    data = SatelliteDataFetcher.parse_response(response)
    SatelliteRecord.create(data)
  end

  def self.parse_response(response)
    altitude     = response["altitude"]
    last_updated = DateTime.strptime(response["last_updated"],"%Y-%m-%dT%H:%M:%S")
    {
      altitude: altitude,
      last_updated: last_updated
    }
  end
end
