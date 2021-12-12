require 'day'

class Day11 < Day
  def self.sample
    {puzzle1: 1656, puzzle2: 195}
  end

  def self.expected
    {puzzle1: 1700, puzzle2: :skipped}
  end

  def display
    puts "--- Day 11: Dumbo Octopus ---"
    puts "How many total flashes are there after 100 steps?"
    puts "- Puzzle 1: #{puzzle1}"
    puts "What is the puzzle 2 result?"
    puts "- Puzzle 2: #{puzzle2}"
  end

  def puzzle1
    self.cave = lines.map {|line| line.chars.map(&:to_i)}
    self.flashes = 0

    100.times { step! }

    flashes
  end

  def puzzle2
    self.cave = lines.map {|line| line.chars.map(&:to_i)}

    1.step do |i|
      self.flashes = 0
      step!
      return i if flashes == (rows * columns)
    end
  end

  protected

  attr_accessor :cave
  attr_accessor :flashed
  attr_accessor :energized
  attr_accessor :flashes

  def rows
    @rows ||= cave.length
  end

  def columns
    @columns ||= cave.first.length
  end

  def step!
    self.flashed = []
    self.energized = []
    rows.times {|i| columns.times {|j| pulse(i, j)}}
    flash(*energized.pop) while energized.any?
    reset(*flashed.pop) while flashed.any?
  end

  def pulse(i, j)
    cave[i][j] += 1
    energize(i, j) if cave[i][j] > 9
  end

  def energize(i, j)
    return if energized.include?([i, j])
    energized.push([i, j])
  end

  def flash(i, j)
    return if flashed.include?([i, j])

    flashed.push([i, j])
    self.flashes += 1

    pulse(i - 1, j    ) if i > 0                           # up
    pulse(i + 1, j    ) if i < rows - 1                    # down
    pulse(i    , j - 1) if j > 0                           # left
    pulse(i    , j + 1) if j < columns - 1                 # right
    pulse(i - 1, j - 1) if i > 0 && j > 0                  # up-left
    pulse(i - 1, j + 1) if i > 0 && j < columns - 1        # up-right
    pulse(i + 1, j - 1) if i < rows - 1 && j > 0           # down-left
    pulse(i + 1, j + 1) if i < rows - 1 && j < columns - 1 # down-right
  end

  def reset(i, j)
    cave[i][j] = 0
  end
end
