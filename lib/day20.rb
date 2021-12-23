require 'day'
require 'set'

class Day20 < Day
  def self.sample
    {puzzle1: 35, puzzle2: 3351}
  end

  def self.expected
    {puzzle1: 5680, puzzle2: 19766}
  end

  def display
    puts "--- Day 20: Trench Map ---"
    puts "How many pixels are lit in the resulting image (2)?"
    puts "- Puzzle 1: #{puzzle1}"
    puts "How many pixels are lit in the resulting image (50)?"
    puts "- Puzzle 2: #{puzzle2}"
  end

  def puzzle1
    load!
    2.times { enhance! }
    pixels.count
  end

  def puzzle2
    load!
    50.times { enhance! }
    pixels.count
  end

  protected

  attr_accessor :pattern, :pixels, :bounds

  def load!
    self.pattern = lines.first.chars.map {|char| char == '#'}
    self.pixels = Set.new
    lines.drop(2).each_with_index do |line, x|
      line.chars.each_with_index do |pixel, y|
        pixels.add([x, y]) if pixel == '#'
      end
    end
    self.bounds = {
      x: Range.new(*pixels.map(&:first).minmax) << -200 >> 200,
      y: Range.new(*pixels.map(&:last).minmax)  << -200 >> 200
    }
  end

  def enhance!
    enhanced = Set.new
    bounds[:x].each do |x|
      bounds[:y].each do |y|
        enhanced.add([x, y]) if lit(x, y)
      end
    end
    self.pixels = enhanced
    bounds[:x] = bounds[:x] <<  3 >> -3
    bounds[:y] = bounds[:y] <<  3 >> -3
  end

  OFFSETS = [
    [-1, -1], [-1, 0], [-1, 1],
    [ 0, -1], [ 0, 0], [ 0, 1],
    [ 1, -1], [ 1, 0], [ 1, 1]
  ]

  def lit(x, y)
    index = OFFSETS.map do |offset|
      pixels.include?([x + offset.first, y + offset.last]) ? '1' : '0'
    end
    pattern[index.flatten.join.to_i(2)]
  end
end

class Range
  def <<(offset)
    (first + offset)..last
  end

  def >>(offset)
    first..(last + offset)
  end

  def *(expansion)
    self << (last - first) * -expansion >> (last - first) * expansion
  end
end