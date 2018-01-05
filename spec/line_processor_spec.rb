require_relative '../lib/result_utils/line_processor'
require 'json'
require 'pry'

RSpec.describe LineProcessor do

  describe '.call' do

    context 'invalid line data' do
      ["", "{", "}", "{id: '13'}"].each do |line|
        it "#{line} should result invalid json" do
          response = LineProcessor.new(line).call
          expect(response.valid).to be false
          expect(response.error).to be :invalid_json
        end
      end

      [
        {"latitude": "52.98", "user_id": "asd12", "name": "Ab", "longitude": "-6.043"}.to_json,
        {"latitude": "252.98", "user_id": 12, "name": "Ab", "longitude": "-6.043"}.to_json,
        {"latitude": "52.98", "user_id": 12, "name": "", "longitude": "-6.043"}.to_json,
        {"latitude": "52.98", "user_id": 12, "name": "Ab", "longitude": "-600.043"}.to_json,
        {"latitude": "52.98", "user_id": 12, "name": "Ab", "longitude": ""}.to_json,
        {"latitude": "52.98", "user_id": "", "name": "Ab", "longitude": "-6.043"}.to_json,
        {"latitude": "52.98", "name": "Ab", "longitude": "-6.043"}.to_json,
        {"latitude": "52.98", "user_id": 12, "longitude": "-6.043"}.to_json,
        {"latitude": "52.98", "user_id": 12, "name": "Ab"}.to_json,
        {"latitude": "52.98", "user_id": "", "name": "Ab", "longitude": "-6.043"}.to_json,
        {"latitude": "", "user_id": "12", "name": "Ab", "longitude": "-6.043"}.to_json,
        {"user_id": "12", "name": "Ab", "longitude": "-6.043"}.to_json,
      ].each do |line|
        it "#{line} should result invalid data" do
          response = LineProcessor.new(line).call
          expect(response.valid).to be false
          expect(response.error).to be :data_missing
        end
      end
    end



    context 'valid line data' do
      [
        {"latitude": "52.98", "user_id": "12", "name": "Ab", "longitude": "-6.043"}.to_json,
        {"latitude": 52.98, "user_id": 12, "name": "Ab 234", "longitude": "-66.043"}.to_json,

      ].each do |line|
        it "#{line} should result data" do
          response = LineProcessor.new(line).call
          expect(response.valid).to be true
          expect(response.data).to a_kind_of Hash
          expect(response.data).to have_key 'id'
          expect(response.data).to have_key 'name'
          expect(response.data).to have_key 'latitude'
          expect(response.data).to have_key 'longitude'
        end
      end
    end
  end
end
