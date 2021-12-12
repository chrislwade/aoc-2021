require 'day'
require 'set'

class Day12 < Day
  def self.sample
    {puzzle1: 226, puzzle2: 3509}
  end

  def self.expected
    {puzzle1: 3292, puzzle2: 89592}
  end

  def display
    puts "--- Day 12: Puzzle Name ---"
    puts "How many paths through this cave system are there that visit small caves at most once?"
    puts "- Puzzle 1: #{puzzle1}"
    puts "How many paths through this cave system are there?"
    puts "- Puzzle 2: #{puzzle2}"
  end

  def puzzle1
    load!
    pathfind!
    paths.count
  end

  def puzzle2
    revisiting!
    puzzle1
  end

  protected

  attr_accessor :caves, :paths, :visited, :extra_visit

  def start_cave
    caves['start']
  end

  def end_cave
    caves['end']
  end

  def revisiting!
    @revisit = true
  end

  def revisiting?
    @revisit
  end

  def load!
    self.caves = Hash.new {|hash, key| hash[key] = Cave.new(key)}
    lines.each do |connection|
      (cave1, cave2) = connection.split('-')
      caves[cave1].connect(caves[cave2])
      caves[cave2].connect(caves[cave1])
    end
  end

  def pathfind!
    self.paths = Set.new
    self.visited = Set.new
    self.extra_visit = false
    visit(start_cave, revisiting? ? [] : [start_cave])
  end

  def visit(cave, path)
    if cave.end?
      paths.add(path.clone)
      return
    end

    if revisiting?
      return if cave.start? && path.any?

      saved_extra_visit = self.extra_visit

      if cave.small? && path.include?(cave)
        return if self.extra_visit
        self.extra_visit = true
      end

      path.push(cave)
      cave.connections.each {|connection| visit(connection, path)}
      path.pop

      self.extra_visit = saved_extra_visit
    else
      visited.add(cave) if cave.small?
      cave.connections.each do |connection|
        unless visited.include?(connection)
          path.push(connection)
          visit(connection, path)
          path.pop
        end
      end
      visited.delete(cave) if cave.small?
    end
  end

  class Cave
    attr_accessor :name
    attr_accessor :connections

    def initialize(name)
      self.name = name
      self.connections = Set.new
    end

    def connect(cave)
      connections.add(cave)
    end

    def ==(other)
      name == other.name
    end

    def start?
      name == 'start'
    end

    def end?
      name == 'end'
    end

    def large?
      !end? && name != name.downcase
    end

    def small?
      !end? && name != name.upcase
    end

    def to_s
      name
    end
  end
end
