class Ahoy::Store < Ahoy::DatabaseStore
end

# set to true for JavaScript tracking
Ahoy.api = true

# set to true for geocoding (and add the geocoder gem to your Gemfile)
# we recommend configuring local geocoding as well
# see https://github.com/ankane/ahoy#geocoding
Ahoy.geocode = true
Ahoy.api_only = true
Ahoy.server_side_visits = true
Safely.report_exception_method = ->(e) { Rollbar.error(e) }
Ahoy.cookies = false
Ahoy.mask_ips = true
