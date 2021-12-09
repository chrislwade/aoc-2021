class Day
  attr_accessor :lines

  def initialize(filename)
    self.lines = File.readlines(filename, chomp: true)
  end
end