require 'day'
require 'fc'
require 'matrix'
require 'set'

class Day15 < Day
  def self.sample
    {puzzle1: 40, puzzle2: 315}
  end

  def self.expected
    {puzzle1: 604, puzzle2: 2907}
  end

  def display
    puts "--- Day 15: Chiton ---"
    puts "What is the lowest total risk of any path from the top left to the bottom right?"
    puts "- Puzzle 1: #{puzzle1}"
    puts "What is the lowest total risk of any path from the top left to the bottom right?"
    puts "- Puzzle 2: #{puzzle2}"
  end

  def puzzle1
    load!
    pathfind
  end

  def puzzle2
    load!
    expand!
    pathfind
  end

  protected

  attr_accessor :grid

  def load!
    self.grid = Matrix[*lines.map {|line, row| line.chars.map(&:to_i)}]
  end

  def expand!
    tile = grid.clone
    4.times do
      grow(tile)
      self.grid = grid.vstack(tile.clone)
    end
    tile = grid.clone
    4.times do
      grow(tile)
      self.grid = grid.hstack(tile.clone)
    end
  end

  def grow(tile)
    tile.map! {|cost| cost == 9 ? 1 : cost + 1}
  end

  def visualize(tile = grid)
    puts '-' * tile.column_count
    tile.row_vectors.each do |row|
      puts row.to_a.join
    end
    puts '-' * tile.column_count
  end

  def pathfind
    cost    = Hash.new(0)
    queue   = FastContainers::PriorityQueue.new(:min)
    visited = Set.new

    queue.push([0, 0], 0)

    until queue.empty?
      c = queue.top_key
      (row, column) = queue.pop

      next if visited.include?([row, column])
      visited.add([row, column])
      cost[[row, column]] = c
      break if row == rows - 1 && column == columns - 1

      [[0, 1], [0, -1], [1, 0], [-1, 0]].each do |dr, dc|
        rr = row + dr
        cc = column + dc

        next unless (0...rows).include?(rr) && (0...columns).include?(cc)

        nc = c + grid[rr, cc]
        queue.push([rr, cc], nc)
      end
    end

    cost[[rows - 1, columns - 1]].to_i
  end

  def rows
    grid.row_count
  end

  def columns
    grid.column_count
  end
end