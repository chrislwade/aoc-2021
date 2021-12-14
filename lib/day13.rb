require 'day'
require 'set'
require 'matrix'

class Day13 < Day
  def self.sample
    # sample input for this puzzle has nothing in the lower two rows
    # and the algorithm used disposes of them :-(
    puzzle2 = <<~EOF.chomp
      #####
      #...#
      #...#
      #...#
      #####
    EOF
    {puzzle1: 17, puzzle2: puzzle2}
  end

  def self.expected
    puzzle2 = <<~EOF.chomp
      ###..####.###...##...##....##.###..###.
      #..#.#....#..#.#..#.#..#....#.#..#.#..#
      #..#.###..#..#.#....#.......#.#..#.###.
      ###..#....###..#....#.##....#.###..#..#
      #....#....#.#..#..#.#..#.#..#.#....#..#
      #....####.#..#..##...###..##..#....###.
    EOF
    {puzzle1: 781, puzzle2: puzzle2}
  end

  def display
    puts "--- Day 13: Transparent Origami ---"
    puts "How many dots are visible after completing just the first fold instruction on your transparent paper?"
    puts "- Puzzle 1: #{puzzle1}"
    puts "What code do you use to activate the infrared thermal imaging camera system?"
    puts "- Puzzle 2: \n#{puzzle2}"
  end

  def puzzle1
    load!
    fold!
    points.count
  end

  def puzzle2
    load!
    while folds.any?
      fold!
    end
    visualize
  end

  protected

  attr_accessor :points, :folds

  def load!
    self.points = lines.select {|line| line.include?(',')}.map {|line| Point.parse(line)}.to_set
    self.folds = lines.select {|line| line.include?('=')}.map {|line| Fold.parse(line)}
  end

  def fold!
    fold = folds.shift

    new_points = Set.new

    points.each do |point|
      if (fold.vertical? ? point.x : point.y) > fold.line
        new_points.add(reflect(point, fold))
      else
        new_points.add(point)
      end
    end

    self.points = new_points
  end

  def reflect(point, fold)
    if fold.vertical?
      Point.new(2 * fold.line - point.x, point.y)
    else
      Point.new(point.x, 2 * fold.line - point.y)
    end
  end

  def visualize
    rows    = points.max_by {|point| point.y}.y + 1
    columns = points.max_by {|point| point.x}.x + 1

    matrix = Matrix.build(rows, columns) { '.' }
    points.each {|point| matrix[point.y, point.x] = '#'}

    matrix.to_a.map {|row| row.to_a.join}.join("\n")
  end

  class Point < Struct.new(:x, :y)
    def self.parse(line) # x,y
      new(*line.split(',').map(&:to_i))
    end

    def ==(other)
      x == other.x && y == other.y
    end
  end

  class Fold < Struct.new(:axis, :line)
    def self.parse(line) # fold along axis=line
      (axis, line) = line.split.last.split('=')
      new(axis, line.to_i)
    end

    def vertical?
      axis == 'x'
    end

    def horizontal?
      axis == 'y'
    end
  end
end
