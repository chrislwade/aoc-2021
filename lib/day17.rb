require 'day'

class Day17 < Day
  def self.sample
    {puzzle1: 45, puzzle2: 112}
  end

  def self.expected
    {puzzle1: 5460, puzzle2: 3618}
  end

  def display
    puts "--- Day 17: Trick Shot ---"
    puts "What is the highest y position it reaches on this trajectory?"
    puts "- Puzzle 1: #{puzzle1}"
    puts "How many distinct initial velocity values cause the probe to be within the target area after any step?"
    puts "- Puzzle 2: #{puzzle2}"
  end

  def puzzle1
    load!
    project!
    hits.max
  end

  def puzzle2
    load!
    project!
    hits.count
  end

  protected

  attr_accessor :range_x, :range_y, :hits

  PATTERN = /target area: x=(?<min_x>-?\d+)\.\.(?<max_x>-?\d+), y=(?<min_y>-?\d+)..(?<max_y>-?\d+)/

  def load!
    match_data = PATTERN.match(lines.first)
    self.range_x = match_data[:min_x].to_i..match_data[:max_x].to_i
    self.range_y = match_data[:min_y].to_i..match_data[:max_y].to_i
  end

  def project!
    self.hits = []
    1.upto(250) do |x_velocity|
      -250.upto(250) do |y_velocity|
        max_y = simulate(x_velocity, y_velocity)
        hits.push(max_y) unless max_y.nil?
      end
    end
  end

  def simulate(x_velocity, y_velocity)
    x, y, max_y = 0, 0, -1

    until x > range_x.last || y < range_y.first
      x += x_velocity
      y += y_velocity

      x_velocity -= (x_velocity.positive? ? 1 : -1) unless x_velocity.zero?
      y_velocity -= 1

      max_y = [max_y, y].max
      return max_y if hit?(x, y)
    end

    return nil
  end

  def hit?(x, y)
    range_x.include?(x) && range_y.include?(y)
  end
end
