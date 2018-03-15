# Load the Rails application.
require_relative 'application'

require_relative '../app/models/services/satellite_data_fetcher'

require_relative '../app/models/services/satellite_reporter'


# Initialize the Rails application.
Rails.application.initialize!
