class Day
  attr_accessor :lines

  def self.focus
    (sample.values + expected.values).any? {|value| value == :skipped}
  end

  def initialize(filename)
    self.lines = File.readlines(filename, chomp: true)
  end
end
