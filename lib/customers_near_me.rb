require_relative "result_builder"

class CustomersNearMe
  attr_reader :latitude, :longitude, :name, :span, :file_path
  # A high limit to handle scale. After these many recrods it is anyways not
  # fisible to absorb in this way.
  MAX_RECORDS = 100_000

  def self.build_with_default_options
    default_options = {
      lat:  53.339428,
      lng:  -6.257664,
      name: 'Dublin office',
      file_path: 'data/customers.json'
    }
    self.new(**default_options)
  end

  def initialize(name:, lat:, lng:, file_path:, span: 100)
    @name      = name
    @latitude  = lat
    @longitude = lng
    @span      = span
    @file_path = file_path
  end

  def call
    response = ResultBuilder.new(self).call
    print_result(response)
  end

  #  ===================
  #  = private methods =
  #  ===================
  private
    def print_result(response)
      if response.data.ids.length.zero?
        if response.errors.present?
          puts response.errors.messages
        else
          puts 'Empty file !'
        end
        return
      end

      if response.errors.present?
        puts "Errors summary: \n #{response.errors.messages.join('\n')}\n#{'---' * 20}"
      end

      puts "\nCustomers near #{name} within #{span}km are #{response.data.count} \n#{'---' * 20}"
      response.data.ids.each do |user_id|
        puts "id: #{user_id}, name: #{response.data.records[user_id]}"
      end
      if (diff = (response.data.count - response.data.ids.length)) > 0
        puts "And #{diff} more customers !"
      end
    end

end

