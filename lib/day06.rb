require 'day'

class Day06 < Day
  def self.expected
    {puzzle1: 5934, puzzle2: 26984457539}
  end

  def display
    puts "--- Day 06: Lanternfish ---"
    puts "How many lanternfish would there be after 80 days?"
    puts "- Puzzle 1: #{puzzle1}"
    puts "How many lanternfish would there be after 256 days?"
    puts "- Puzzle 2: #{puzzle2}"
  end

  def puzzle1
    80.times { simulate! }
    fish.values.sum
  end

  def puzzle2
    256.times { simulate! }
    fish.values.sum
  end

  protected

  def fish
    @fish ||= lines.first.split(',').map(&:to_i).tally
  end

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
