require_relative "../lib/customers_near_me"

RSpec.describe CustomersNearMe do
  subject { CustomersNearMe.build_with_default_options }
  let (:options) do
    { name: 'test location',
      lat: 53.339428,
      lng: -6.257664,
      file_path: 'spec/data_files/valid_file.txt'
    }
  end

  it { should respond_to(:call) }

  describe '.build_with_default_options' do
    it 'returns new object with default config options' do
      default_options = {
        lat:  53.339428,
        lng:  -6.257664,
        name: 'Dublin office',
        file_path: 'data/customers.json'
      }
      expect(subject.name).to eq(default_options[:name])
      expect(subject.latitude).to eq(default_options[:lat])
      expect(subject.longitude).to eq(default_options[:lng])
      expect(subject.file_path).to eq(default_options[:file_path])
    end
  end

  describe '.new' do
    it 'returns new object with given config' do

      main_obj = CustomersNearMe.new(options)

      expect(main_obj.name).to eq(options[:name])
      expect(main_obj.latitude).to eq(options[:lat])
      expect(main_obj.longitude).to eq(options[:lng])
      expect(main_obj.file_path).to eq(options[:file_path])
    end
  end

  describe '#call' do
    it 'print valid output' do
      main_obj = CustomersNearMe.new(options)
      expect { main_obj.call }.to output(/100km/).to_stdout
      expect { main_obj.call }.to_not output(/more customers/).to_stdout
    end

    context 'file with no rows' do
      it 'returns Empty file message' do
        options[:file_path] = 'spec/data_files/empty.txt'
        main_obj = CustomersNearMe.new(options)
        expect { main_obj.call }.to output(/Empty file/).to_stdout
      end
    end

    context 'file with valid rows' do
      it 'returns customers list' do
        options[:file_path] = 'spec/data_files/valid_file.txt'
        main_obj = CustomersNearMe.new(options)
        expect { main_obj.call }.to output(/Customers near/).to_stdout
        expect { main_obj.call }.to output(/id(.+)name/).to_stdout
      end
    end

    context 'file with few invalid rows' do
      it 'returns Errors summary message' do
        options[:file_path] = 'spec/data_files/invalid_json_rows.json'
        main_obj = CustomersNearMe.new(options)
        expect { main_obj.call }.to output(/Errors summary/).to_stdout
        expect { main_obj.call }.to output(/invalid json rows/).to_stdout
      end
    end
  end

end
