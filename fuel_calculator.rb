# frozen_string_literal: true

class FuelCalculator
  GRAVITY = {
    earth: 9.807,
    moon: 1.62,
    mars: 3.711
  }.freeze

  ACTIONS = %i[land launch].freeze

  COEFFICIENTS = {
    land: {
      b: 0.033,
      offset: 42
    },
    launch: {
      b: 0.042,
      offset: 33
    }
  }.freeze

  def initialize(mass, trip_plan)
    @trip_plan = trip_plan
    @mass = mass

    validate_args
  end

  def calculate
    trip_plan.reverse.inject(0) do |result, (action, planet)|
      result + calculate_fuel(mass + result, GRAVITY[planet], action)
    end
  end

  private

  attr_reader :trip_plan, :mass

  def validate_args
    trip_plan.each do |(action, planet)|
      raise ArgumentError, "Wrong action: #{action}" unless ACTIONS.include?(action)

      raise ArgumentError, "Gravity is unknown for planet: #{planet}" unless GRAVITY.key?(planet.to_sym)
    end
  end

  def calculate_fuel(mass, gravity, action)
    fuel_required = (mass * gravity * COEFFICIENTS[action][:b] - COEFFICIENTS[action][:offset]).to_i

    return 0 if fuel_required.negative?

    fuel_required + calculate_fuel(fuel_required, gravity, action)
  end
end
