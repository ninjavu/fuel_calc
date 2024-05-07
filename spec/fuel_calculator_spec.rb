# frozen_string_literal: true

require './fuel_calculator'

RSpec.describe FuelCalculator do
  describe '#calculate_total_fuel' do
    let(:trip_plan) { [%i[launch earth], %i[land moon], %i[launch moon], %i[land earth]] }

    it 'calculates total fuel for a trip plan' do
      expect(FuelCalculator.new(28_801, trip_plan).calculate).to eq(51_898)
    end
  end

  context 'with invalid arguments' do
    it 'raises ArgumentError if trip plan has invalid action' do
      expect do
        FuelCalculator.new(100, [%i[jump earth]]).calculate
      end.to raise_error(ArgumentError, 'Wrong action: jump')
    end

    it 'raises ArgumentError if trip plan has invalid planet' do
      expect do
        FuelCalculator.new(100,
                           [%i[launch neptun]]).calculate
      end.to raise_error(ArgumentError, 'Gravity is unknown for planet: neptun')
    end
  end
end
