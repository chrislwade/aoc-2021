require 'day'

class Day22 < Day
  def self.sample
    {puzzle1: 590784, puzzle2: 2758514936282235}
  end

  def self.expected
    {puzzle1: 542711, puzzle2: 1160303042684776}
  end

  def display
    puts "--- Day 22: Reactor Reboot ---"
    puts "How many cubes are on?"
    puts "- Puzzle 1: #{puzzle1}"
    puts "How many cubes are on?"
    puts "- Puzzle 2: #{puzzle2}"
  end

  def puzzle1
    reboot(Cubeoid.new(-50..50, -50..50, -50..50))
  end

  def puzzle2
    reboot
  end

  protected

  def reboot(limit = nil)
    cubeoids = Hash.new(0)

    lines.each do |line|
      (state, ranges) = line.split
      pending = Cubeoid.new(*ranges.split(',').map {|r| r[2..-1].to_range})

      next unless limit.nil? || limit.cover?(pending)

      cubes = Hash.new(0)
      cubeoids.keys.each do |cubeoid|
        overlap = pending.intersect(cubeoid)
        next if overlap.nil?
        cubes[overlap] -= cubeoids[cubeoid]
      end
      cubes[pending] += 1 if state == 'on'
      cubes.each {|cubeoid, count| cubeoids[cubeoid] += count}
    end

    cubeoids.map {|cubeoid, count| cubeoid.volume * count}.sum
  end

  class Cubeoid < Struct.new(:x_range, :y_range, :z_range)
    def each
      x_range.each do |x|
        y_range.each do |y|
          z_range.each do |z|
            yield(x,y,z)
          end
        end
      end
    end

    def cover?(other)
      x_range.cover?(other.x_range) && y_range.cover?(other.y_range) && z_range.cover?(other.z_range)
    end

    def intersect(other)
      x = x_range.intersect(other.x_range)
      y = y_range.intersect(other.y_range)
      z = z_range.intersect(other.z_range)

      [x,y,z].any?(&:nil?) ? nil : Cubeoid.new(x,y,z)
    end

    def volume
      x_range.size * y_range.size * z_range.size
    end

    def empty?
      volume.zero?
    end
  end
end

class String
  def to_range
    Range.new(*split('..').map(&:to_i))
  end
end

class Range
  def overlap?(other)
    cover?(other.first) || other.cover?(first)
  end

  def intersect(other)
    overlap?(other) ? [first, other.first].max..[last, other.last].min : nil
  end
end