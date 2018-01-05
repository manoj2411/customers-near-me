require_relative "errors_struct"

Response = Struct.new(:data, :errors)
Records  = Struct.new(:ids, :records, :count)
