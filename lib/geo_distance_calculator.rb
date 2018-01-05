# This is pure executor without having its own state/data.
# It just the takes input and execute the algorithm.
module GeoDistanceCalculator
  module_function

  EARTH_RADIUS = 6371.00  # Earth's radius in kms

  def get_distance(lat1, lng1, lat2, lng2)
    validate_lat_lngs(lat1, lng1)
    validate_lat_lngs(lat2, lng2)

    lat1 = to_radians(lat1)
    lng1 = to_radians(lng1)
    lat2 = to_radians(lat2)
    lng2 = to_radians(lng2)

    distance = Math.acos(Math.sin(lat1) *
               Math.sin(lat2) + Math.cos(lat1) *
               Math.cos(lat2) * Math.cos(lng1 - lng2))
    (distance * EARTH_RADIUS).round
  end

  def to_radians(degrees)
    degrees * (Math::PI / 180.0)
  end

  def valid_lat?(lat)
    (-90..90).cover? lat
  end

  def valid_lng?(lng)
    (-180..180).cover? lng
  end

  def validate_lat_lngs(lat, lng)
    raise 'Invalid latitude' unless valid_lat?(lat)
    raise 'Invalid longitude' unless valid_lng?(lng)
  end
end
