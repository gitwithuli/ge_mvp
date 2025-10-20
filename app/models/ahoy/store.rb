class Ahoy::Store < Ahoy::DatabaseStore
  # disable geocoding in dev to avoid extra lookups
  def geocode(ip); end
end
