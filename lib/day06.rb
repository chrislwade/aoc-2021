require 'day'

class Day06 < Day
  def self.sample
    {puzzle1: 5934, puzzle2: 26984457539}
  end

  def self.expected
    {puzzle1: 346063, puzzle2: 1572358335990}
  end

  def display
    puts "--- Day 06: Lanternfish ---"
    puts "How many lanternfish would there be after 80 days?"
    puts "- Puzzle 1: #{puzzle1}"
    puts "How many lanternfish would there be after 256 days?"
    puts "- Puzzle 2: #{puzzle2}"
  end

  def puzzle1
    self.fish = lines.first.split(',').map(&:to_i).tally
    80.times { simulate! }
    fish.values.sum
  end

  def puzzle2
    self.fish = lines.first.split(',').map(&:to_i).tally
    256.times { simulate! }
    fish.values.sum
  end

  protected

  attr_accessor :fish

  def simulate!
    newborns = fish[0]
    fish[7] = (fish[0] || 0) + (fish[7] || 0)
    fish.delete(0)
    fish.transform_keys!{|timer| timer - 1}
    if !newborns.nil?
      fish[8] = newborns
    end
  end
end
