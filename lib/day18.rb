require 'day'
require 'json'

class Day18 < Day
  def self.sample
    {puzzle1: 4140, puzzle2: 3993}
  end

  def self.expected
    {puzzle1: 3486, puzzle2: 4747}
  end

  def display
    puts "--- Day 18: Snailfish ---"
    puts "What is the magnitude of the final sum?"
    puts "- Puzzle 1: #{puzzle1}"
    puts "What is the largest magnitude of any sum of two different snailfish numbers from the homework assignment?"
    puts "- Puzzle 2: #{puzzle2}"
  end

  def puzzle1
    lines.map {|line| Node.parse(JSON.parse(line))}.reduce(:+).magnitude
  end

  def puzzle2
    lines.permutation(2).map {|x, y| (Node.parse(JSON.parse(x)) + Node.parse(JSON.parse(y))).magnitude}.max
  end

  protected

  class Node
    attr_accessor :value, :left, :right, :parent

    def self.parse(number, parent: nil)
      node = Node.new(parent: parent)

      if number.is_a?(Integer)
        node.value = number
      else
        node.left = Node.parse(number.first, parent: node)
        node.right = Node.parse(number.last, parent: node)
      end

      return node.reduce
    end

    def initialize(value: nil, left: nil, right: nil, parent: nil)
      self.value = value

      self.left   = left
      left.parent = self unless left.nil?

      self.right   = right
      right.parent = self unless right.nil?

      self.parent = parent
    end

    def +(other)
      Node.new(left: self, right: other).reduce
    end

    def to_s
      value.nil? ? "[#{left.to_s},#{right.to_s}]" : value.to_s
    end

    def magnitude
      value.nil? ? 3 * left.magnitude + 2 * right.magnitude : value
    end

    def reduce
      loop do
        next if explode!
        next if split!
        break
      end
      self
    end

    def explode!
      stack = [[self, 0]]

      until stack.empty?
        node, depth = *stack.pop
        next if node.nil?

        if depth >= 4 && node.value.nil? &&
          ((node.left.nil? && node.right.nil?) || (!node.left.value.nil? && !node.right.value.nil?))
          explode_left!(node)
          explode_right!(node)

          node.value = 0
          node.left = node.right = nil

          return true
        end

        stack.push([node.right, depth + 1])
        stack.push([node.left, depth + 1])
      end

      return false
    end

    def explode_left!(node)
      previous = node.left
      current  = node

      while !current.nil? && (current.left == previous || current.left.nil?)
        previous = current
        current  = current.parent
      end

      unless current.nil?
        current = current.left
        while current.value.nil?
          current = current.right.nil? ? current.left : current.right
        end
        current.value += node.left.value
      end
    end

    def explode_right!(node)
      previous = node.right
      current  = node

      while !current.nil? && (current.right == previous || current.right.nil?)
        previous = current
        current  = current.parent
      end

      unless current.nil?
        current = current.right
        while current.value.nil?
          current = current.left.nil? ? current.right : current.left
        end
        current.value += node.right.value
      end
    end

    def split!
      stack = [self]

      until stack.empty?
        node = stack.pop
        next if node.nil?

        unless node.value.nil?
          if node.value >= 10
            node.left  = Node.new(value: (node.value.to_f / 2).floor, parent: node)
            node.right = Node.new(value: (node.value.to_f / 2).ceil,  parent: node)
            node.value = nil

            return true
          end
        end

        stack.push(node.right)
        stack.push(node.left)
      end

      return false
    end
  end
end