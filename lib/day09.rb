require 'day'
require 'set'

class Day09 < Day
  def self.sample
    {puzzle1: 15, puzzle2: 1134}
  end

  def self.expected
    {puzzle1: 607, puzzle2: 900864}
  end

  def display
    puts "--- Day 09: Smoke Basin ---"
    puts "What is the sum of the risk levels of all low points on your heightmap?"
    puts "- Puzzle 1: #{puzzle1}"
    puts "What do you get if you multiply together the sizes of the three largest basins?"
    puts "- Puzzle 2: #{puzzle2}"
  end

  def puzzle1
    low_points = []

    heightmap.each_with_index do |row, i|
      row.each_with_index do |height, j|
        low_points.push(height) if is_low_point?(i, j)
      end
    end

    low_points.map {|height| height + 1}.sum
  end

  def puzzle2
    basins = []

    heightmap.each_with_index do |row, i|
      row.each_with_index do |height, j|
        if is_low_point?(i, j)
          basins.push(expand(i, j))
        end
      end
    end

    basins.map(&:length).sort.reverse.slice(0, 3).reduce(&:*)
  end

  protected

  def heightmap
    @heightmap ||= lines.map {|line| line.chars.map(&:to_i)}
  end

  def is_low_point?(i, j)
    up    = i > 0 ? heightmap[i - 1][j] : nil
    down  = i < heightmap.length - 1 ? heightmap[i + 1][j] : nil
    left  = j > 0 ? heightmap[i][j - 1] : nil
    right = j < heightmap[i].length - 1 ? heightmap[i][j + 1] : nil

    [up, down, left, right].compact.all? {|neighbor| heightmap[i][j] < neighbor}
  end

  def expand(i, j, basin = [], visited = Set.new)
    return if visited.include?([i, j])

    basin.push([i, j])
    visited.add([i, j])

    expand(i - 1, j, basin, visited) if i > 0 && heightmap[i - 1][j] < 9
    expand(i + 1, j, basin, visited) if i < heightmap.length - 1 && heightmap[i + 1][j] < 9
    expand(i, j - 1, basin, visited) if j > 0 && heightmap[i][j - 1] < 9
    expand(i, j + 1, basin, visited) if j < heightmap[i].length - 1 && heightmap[i][j + 1] < 9

    return basin
  end
end
