require 'day'

class Day14 < Day
  def self.sample
    {puzzle1: 1588, puzzle2: 2188189693529}
  end

  def self.expected
    {puzzle1: 3259, puzzle2: 3459174981021}
  end

  def display
    puts "--- Day 14: Extended Polymerization ---"
    puts "What do you get if you take the quantity of the most common element and subtract the quantity of the least common element?"
    puts "- Puzzle 1: #{puzzle1}"
    puts "What do you get if you take the quantity of the most common element and subtract the quantity of the least common element?"
    puts "- Puzzle 2: #{puzzle2}"
  end

  def puzzle1
    load!
    10.times { insert! }
    occurrences = elements.values.sort
    occurrences.last - occurrences.first
  end

  def puzzle2
    load!
    40.times { insert! }
    occurrences = elements.values.sort
    occurrences.last - occurrences.first
  end

  protected

  attr_accessor :elements, :template, :rules

  def load!
    self.elements = lines.first.chars.tally
    self.elements.default_proc = ->(hash, key) { hash[key] = 0}
    self.template = lines.first.chars.each_cons(2).to_a.map(&:join).tally
    self.rules = Hash[*lines.drop(2).map {|line| line.split(' -> ')}.flatten]
  end

  def insert!
    new_template = Hash.new {|hash, key| hash[key] = 0}

    template.each do |pair, count|
      if rules.has_key?(pair)
        insertion = rules[pair]
        new_template[pair[0] + insertion] += count
        new_template[insertion + pair[1]] += count
        elements[insertion] += count
      else
        new_template[pair] = count
      end
    end

    self.template = new_template
  end
end
