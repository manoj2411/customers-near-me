require_relative "../lib/customers_near_me"
require_relative "../lib/result_builder"

RSpec.describe ResultBuilder do
  let (:runner) { CustomersNearMe.build_with_default_options }
  subject { described_class.new(runner) }

  describe '#call' do
    context 'invalid file name' do
      it 'returns file does not exists message' do
        options = { lat: 53.339428, lng: -6.257664, name: 'Dublin office',
                    file_path: 'abcd/123.txt'}

        response = ResultBuilder.new(CustomersNearMe.new(options)).call
        expect(response.errors).to be_present
        expect(response.errors.messages).to include('Source file does not exists!')

      end
    end

    context 'file with invalid rows' do
      let (:result_builder) do
        options = { lat: 53.339428, lng: -6.257664, name: 'Dublin office',
                    file_path: 'spec/data_files/invalid_json_rows.json'}
        ResultBuilder.new(CustomersNearMe.new(options))
      end

      it 'returns invalid rows in errors' do
        response = result_builder.call
        expect(response.errors).to be_present
        expect(response.errors.messages.any?{|e|e.include?('invalid json rows')}).to eq true
      end

      it 'returns few valid rows ' do
        response = result_builder.call
        expect(response.data.length).to be > 0
      end
    end

  end
end
