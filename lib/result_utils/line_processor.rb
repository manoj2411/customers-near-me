require 'json'
require_relative '../geo_distance_calculator'

class LineProcessor
  Response = Struct.new(:data, :valid, :error)

  attr_accessor :response
  attr_reader :line

  def initialize(line)
    @line = line
    @response = Response.new({}, true)
  end

  def call
    validate_and_set_attributes
    response
  end

  #  ===========
  #  = private =
  #  ===========
  private
    attr_reader :parsed_hash

    def validate_and_set_attributes
      return unless parsed_hash = parse_json
      validate_and_set_id(parsed_hash['user_id'])
      validate_and_set_name(parsed_hash['name']) if response.valid
      validate_and_set_lat_lng(parsed_hash) if response.valid
    end

    def parse_json
      JSON.parse(line)
      rescue JSON::ParserError => e
        response.error = :invalid_json
        response.valid = false
        return false
    end

    def validate_and_set_id(id)
      if id.to_i == 0
        response.error = :data_missing
        response.valid = false
      end
      response.data['id'] = id.to_i
    end

    def validate_and_set_name(name)
      if name.to_s.empty?
        response.error = :data_missing
        response.valid = false
      end
      response.data['name'] = name
    end

    def validate_and_set_lat_lng(hash)
      lat = Float(hash['latitude']) rescue nil
      lng = Float(hash['longitude']) rescue nil
      if lat.nil? || lng.nil? ||
        !(GeoDistanceCalculator.valid_lat?(lat) && GeoDistanceCalculator.valid_lng?(lng))
        response.error = :data_missing
        response.valid = false
      end
      response.data['latitude'] = lat
      response.data['longitude'] = lng
    end

end
