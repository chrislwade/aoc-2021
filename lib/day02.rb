require 'day'

class Day02 < Day
  def self.expected
    {puzzle1: 150, puzzle2: 900}
  end

  def display
    puts "--- Day 02: Dive! ---"
    puts "What do you get if you multiply your final horizontal position by your final depth?"
    puts "- Puzzle 1: #{puzzle1}"
    puts "What do you get if you multiply your final horizontal position by your final depth?"
    puts "- Puzzle 2: #{puzzle2}"
  end

  def puzzle1
    position = 0
    depth = 0

    lines.each do |line|
      (command, units) = line.split
      units = units.to_i

      case command
      when 'forward' then position += units
      when 'down'    then depth += units
      when 'up'      then depth -= units
      end
    end

    position * depth
  end

  def puzzle2
    position = 0
    depth = 0
    aim = 0

    lines.each do |line|
      (command, units) = line.split
      units = units.to_i

      case command
      when 'forward'
        position += units
        depth += aim * units
      when 'down'
        aim += units
      when 'up'
        aim -= units
      end
    end

    position * depth
  end

  def position
    horizontal_position * depth
  end

  def aim_adjusted_position
    horizontal_position * aim_adjusted_depth
  end
end
