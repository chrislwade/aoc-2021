require 'day'

class Day03 < Day
  def self.sample
    {puzzle1: 198, puzzle2: 230}
  end

  def self.expected
    {puzzle1: 845186, puzzle2: 4636702}
  end

  def display
    puts "--- Day 03: Binary Diagnostic ---"
    puts "What is the power consumption of the submarine?"
    puts "- Puzzle 1: #{puzzle1}"
    puts "What is the life support rating of the submarine?"
    puts "- Puzzle 2: #{puzzle2}"
  end

  def puzzle1
    gamma_rate * epsilon_rate
  end

  def puzzle2
    oxygen_generator_rating * co2_scrubber_rating
  end

  protected

  def values
    @values ||= lines.map(&:chars)
  end

  def gamma_rate
    Bit.bits(values).map(&:most_common).join.to_i(2)
  end

  def epsilon_rate
    Bit.bits(values).map(&:least_common).join.to_i(2)
  end

  def oxygen_generator_rating
    readings = values.clone
    index = 0
    while readings.length > 1
      bits = Bit.bits(readings)
      keep = bits[index].same ? '1' : bits[index].most_common
      readings.select! do |reading|
        reading[index] == keep
      end
      index += 1
    end
    readings.first.join.to_i(2)
  end

  def co2_scrubber_rating
    readings = values.clone
    index = 0
    while readings.length > 1
      bits = Bit.bits(readings)
      keep = bits[index].same ? '0' : bits[index].least_common
      readings.select! do |reading|
        reading[index] == keep
      end
      index += 1
    end
    readings.first.join.to_i(2)
  end

  class Bit
    attr_accessor :bit

    def self.bits(values)
      bits = Array.new(values.first.length) {Bit.new}

      values.each do |value|
        value.each_with_index do |bit, index|
          bits[index][bit.to_i] += 1
        end
      end

      return bits
    end

    def initialize
      self.bit = [0, 0]
    end

    def [](index)
      bit[index]
    end

    def []=(index, value)
      bit[index] = value
    end

    def most_common
      bit[0] > bit[1] ? '0' : '1'
    end

    def least_common
      bit[0] < bit[1] ? '0' : '1'
    end

    def same
      bit[0] == bit[1]
    end
  end
end