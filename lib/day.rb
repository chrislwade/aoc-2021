class Day
  attr_accessor :lines

  def self.focus
    false
  end

  def initialize(filename)
    self.lines = File.readlines(filename, chomp: true)
  end
end
