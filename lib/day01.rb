require 'day'

class Day01 < Day
  def self.expected
    {puzzle1: 7, puzzle2: 5}
  end

  def display
    puts "--- Day 01: Sonar Sweep ---"
    puts "How many measurements are larger than the previous measurement?"
    puts "- Puzzle 1: #{puzzle1}"
    puts "How many sums are larger than the previous sum?"
    puts "- Puzzle 2: #{puzzle2}"
  end

  def puzzle1
    previous  = nil
    increased = 0

    readings.each do |reading|
      if !previous.nil? && reading > previous
        increased += 1
      end
      previous = reading
    end

    increased
  end

  def puzzle2
    previous  = nil
    increased = 0
    window    = []

    readings.each do |reading|
      window.push(reading)

      if window.length == 4
        window.shift
      end

      if window.length == 3
        reading = window.sum
        if !previous.nil? && reading > previous
          increased += 1
        end
        previous = reading
      end
    end

    increased
  end

  protected

  def readings
    lines.map(&:to_i)
  end
end
