class Day
  attr_accessor :lines

  def initialize(filename)
    self.lines = File.readlines(filename, chomp: true)
  end

  def self.sample
    {puzzle1: :skipped, puzzle2: :skipped}
  end

  def self.expected
    {puzzle1: :skipped, puzzle2: :skipped}
  end
end
