require 'day'

class Day10 < Day
  def self.sample
    {puzzle1: 26397, puzzle2: 288957}
  end

  def self.expected
    {puzzle1: 215229, puzzle2: 1105996483}
  end

  def display
    puts "--- Day 10: Syntax Scoring ---"
    puts "What is the total syntax error score for those errors?"
    puts "- Puzzle 1: #{puzzle1}"
    puts "What is the middle score?"
    puts "- Puzzle 2: #{puzzle2}"
  end

  def puzzle1
    lines.map {|line| corruption_score(line)}.compact.sum
  end

  def puzzle2
    lines.reject {|line| corruption_score(line) > 0}.map {|line| completion_score(line)}.sort.middle
  end

  protected

  def corruption_score(line)
    stack = []

    line.chars.each do |char|
      if OPEN.keys.include?(char)
        stack.push(char)
      elsif stack.last != CLOSE[char]
        return CORRUPTION_POINTS[char]
      else
        stack.pop
      end
    end

    return 0
  end

  def completion_score(line)
    stack = []

    line.chars.each do |char|
      if OPEN.keys.include?(char)
        stack.push(char)
      else
        stack.pop
      end
    end

    stack.reverse.map {|char| OPEN[char]}.reduce(0) {|acc, char| acc * 5 + COMPLETION_POINTS[char]}
  end

  CORRUPTION_POINTS = { ')' => 3, ']' => 57, '}' => 1197, '>' => 25137 }
  COMPLETION_POINTS = { ')' => 1, ']' => 2, '}' => 3, '>' => 4 }
  OPEN = { '(' => ')', '[' => ']', '{' => '}', '<' => '>' }
  CLOSE = OPEN.invert
end

class Array
  def middle
    self[length / 2]
  end
end
