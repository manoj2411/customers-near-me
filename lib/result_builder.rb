require 'pry'
require 'json'
require 'set'
require_relative 'geo_distance_calculator'
require_relative 'result_utils/structs'
require_relative 'result_utils/line_processor'

class ResultBuilder

  attr_reader :config, :response

  def initialize(config)
    @config = config
    result_set = Records.new(SortedSet.new, {}, 0)
    @response = Response.new(result_set, Errors.new)
  end

  def call
    validate_and_set_file
    process_file if response.errors.blank?
    response # return response
  end

  #  ===================
  #  = Private methods =
  #  ===================
  private
    attr_reader :source_file

    def validate_and_set_file
      if File.exists? config.file_path
        @source_file = File.open(config.file_path,'r')
      else
        response.errors.file ||= 'Source file does not exists!'
        return false
      end
    end

    def process_file
      source_file.each do|line|
        result = LineProcessor.new(line).call
        unless result.valid
          response.errors[result.error] ||= 0
          response.errors[result.error] += 1
          next
        end
        process_line_result(result.data)
      end
    end

    def process_line_result(attrs)
      # if record is valid then add it ot records list
      distance = GeoDistanceCalculator.get_distance(config.latitude,
                                                    config.longitude,
                                                    attrs['latitude'],
                                                    attrs['longitude'])
      # applying filter
      if distance <= config.span
        if response.data.count < CustomersNearMe::MAX_RECORDS
          add_record(attrs)
        elsif attrs['id'] < (max = response.data.ids.max)
          response.data.ids.delete(max)
          response.data.records.delete(max)
          add_record(attrs)
        end
        response.data.count += 1
      end
    end

    def add_record(record)
      response.data.ids.add(record['id']) #
      response.data.records[record['id']] = record['name']
    end
end
