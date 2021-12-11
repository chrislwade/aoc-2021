require 'day'

class Day05 < Day
  def self.sample
    {puzzle1: 5, puzzle2: 12}
  end

  def self.expected
    {puzzle1: 8622, puzzle2: 22037}
  end

  def display
    puts "--- Day 05: Hydrothermal Venture ---"
    puts "At how many points do at least two lines overlap?"
    puts "- Puzzle 1: #{puzzle1}"
    puts "At how many points do at least two lines overlap?"
    puts "- Puzzle 2: #{puzzle2}"
  end

  def puzzle1
    segments
      .select{|segment| segment.vertical? || segment.horizontal?}
      .map(&:points)
      .flatten
      .tally
      .select{|point, count| count > 1}
      .keys
      .count
  end

  def puzzle2
    segments
      .map(&:points)
      .flatten
      .tally
      .select{|point, count| count > 1}
      .keys
      .count
  end

  protected

  def segments
    @segments ||= lines.map {|line| Segment.parse(line)}
  end
end

class Segment < Struct.new(:point1, :point2)
  class DiagonalSegmentException < Exception; end

  def self.parse(segment)
    new(*segment.split(' -> ').map {|point| Point.parse(point)})
  end

  def horizontal?
    point1.y == point2.y
  end

  def vertical?
    point1.x == point2.x
  end

  def points
    xs = [point1.x, point2.x]
    ys = [point1.y, point2.y]
    if horizontal?
      (xs.min .. xs.max).map {|x| Point.new(x, point1.y)}
    elsif vertical?
      (ys.min .. ys.max).map {|y| Point.new(point1.x, y)}
    else
      lp = point1.x < point2.x ? point1 : point2
      rp = point1.x > point2.x ? point1 : point2
      (0 .. ys.max - ys.min).map {|d| Point.new(lp.x + d, lp.y > rp.y ? lp.y - d : lp.y + d)}
    end
  end
end

class Point < Struct.new(:x, :y)
  def self.parse(point)
    new(*point.split(',').map(&:to_i))
  end

  def ==(other)
    x == other.x && y == other.y
  end
end
