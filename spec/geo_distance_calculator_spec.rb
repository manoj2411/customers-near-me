require_relative "../lib/geo_distance_calculator"
require 'pry'

RSpec.describe GeoDistanceCalculator do

  describe '.get_distance' do
    it 'returns less then 50km distance' do
      location1 = [53.339428,-6.257664]
      location2 = [52.986375,-6.043701]

      distance = GeoDistanceCalculator.get_distance(*(location1 + location2))
      expect(distance).to be < 50
      expect(distance).to be > 20
    end

    it 'returns greater then 50km distance' do
      location1 = [53.339428,-6.257664]
      location2 = [54.0894797,-6.18671]

      distance = GeoDistanceCalculator.get_distance(*(location1 + location2))
      expect(distance).to be > 50
      expect(distance).to be < 100
    end
  end

  describe '.to_radians' do
    it 'returns radians from degrees' do
      lat, lng = [53.339428,-6.257664]

      expect(GeoDistanceCalculator.to_radians(lat)).to eq(lat * (Math::PI / 180.0))
      expect(GeoDistanceCalculator.to_radians(lng)).to eq(lng * (Math::PI / 180.0))
    end
  end

  describe '.valid_lat?' do
    it 'returns true for valid latitude' do
      expect(GeoDistanceCalculator.valid_lat?(53.339428)).to eq true
    end
    it 'returns false for invalid latitude' do
      expect(GeoDistanceCalculator.valid_lat?(153.339428)).to eq false
    end
  end

  describe '.valid_lng?' do
    it 'returns true for valid longitude' do
      expect(GeoDistanceCalculator.valid_lng?(-6.257664)).to eq true
    end
    it 'returns false for invalid longitude' do
      expect(GeoDistanceCalculator.valid_lng?(-226.257664)).to eq false
    end
  end

  describe '.validate_lat_lngs' do
    it 'raises exception for invalid latitude or longitude' do
      expect { Object.new.foo }.to raise_error
      expect{GeoDistanceCalculator.validate_lat_lngs(153.339428,-6.257664)}.
        to raise_error('Invalid latitude')
      expect{GeoDistanceCalculator.validate_lat_lngs(53.339428,-226.257664)}.
        to raise_error('Invalid longitude')
    end

    it 'not raises exception for ivalid latitude and longitude' do
      expect { Object.new.foo }.to raise_error
      expect{GeoDistanceCalculator.validate_lat_lngs(53.339428,-6.257664)}.
        to_not raise_error(RuntimeError)
    end

  end

end
