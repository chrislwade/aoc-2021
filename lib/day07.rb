require 'day'

class Day07 < Day
  def self.sample
    {puzzle1: 37, puzzle2: 168}
  end

  def self.expected
    {puzzle1: 329389, puzzle2: 86397080}
  end

  def display
    puts "--- Day 07: The Treachery of Whales ---"
    puts "How much fuel must they spend to align to that position?"
    puts "- Puzzle 1: #{puzzle1}"
    puts "How much fuel must they spend to align to that position?"
    puts "- Puzzle 2: #{puzzle2}"
  end

  def puzzle1
    (crabs.min .. crabs.max).map do |position|
      crabs.map {|crab| (crab - position).abs}.sum
    end.min
  end

  def puzzle2
    (crabs.min .. crabs.max).map do |position|
      crabs.map {|crab| triangular((crab - position).abs)}.sum
    end.min
  end

  protected

  def crabs
    @crabs ||= lines.first.split(',').map(&:to_i)
  end

  def triangular(n)
    n * (n + 1) / 2
  end
end
