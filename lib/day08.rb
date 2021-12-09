require 'day'
require 'set'

class Day08 < Day
  def self.expected
    {puzzle1: 26, puzzle2: 61229}
  end

  def display
    puts "--- Day 08: Seven Segment Search ---"
    puts "In the output values, how many times do digits 1, 4, 7, or 8 appear?"
    puts "- Puzzle 1: #{puzzle1}"
    puts "What do you get if you add up all of the output values?"
    puts "- Puzzle 2: #{puzzle2}"
  end

  def puzzle1
    lines.map do |line|
      (records, outputs) = line.split(' | ')
      outputs.split.select {|output| unique_digit?(output)}
    end.flatten.compact.count
  end

  def puzzle2
    lines.map do |line|
      (records, outputs) = line.split(' | ')
      SegmentMap.new(records.split).translate(outputs.split)
    end.sum
  end

  protected

  UNIQUE_DIGITS = {1 => 2, 4 => 4, 7 => 3, 8 => 7}

  def unique_digit?(output)
    UNIQUE_DIGITS.values.include?(output.length)
  end

  class SegmentMap
    class DecodeError < StandardError; end

    attr_accessor :segments
    attr_accessor :signals
    attr_accessor :codes
    attr_accessor :five, :six

    def initialize(signals)
      self.signals = signals

      self.segments = []
      self.codes = {}
      self.five = []
      self.six = []

      first_pass!
      segments[0] = codes[7] - codes[1]
      second_pass!
      segments[4] = codes[8] - codes[9]
      segments[6] = codes[8] - codes[7] - codes[4] - segments[4]
      third_pass!
      segments[1] = codes[8] - codes[3] - segments[4]
      segments[2] = codes[8] - codes[6]
      segments[5] = codes[1] - segments[2]
    end

    def translate(outputs)
      outputs.map {|output| decode(output)}.join.to_i
    end

    protected

    def first_pass!
      signals.each do |signal|
        case signal.length
        when 2 then codes[1] = signal
        when 4 then codes[4] = signal
        when 3 then codes[7] = signal
        when 7 then codes[8] = signal
        when 5 then five.push(signal)   # 2,3,5
        when 6 then six.push(signal)    # 0,6,9
        end
      end
    end

    def second_pass!
      six.each do |signal|
        if (signal - codes[7] - codes[4]).length == 1
          codes[9] = signal
        end

        if (signal - codes[7]).length == 4
          codes[6] = signal
        end
      end
    end

    def third_pass!
      five.each do |signal|
        segment = signal - codes[7] - segments[6]
        if segment.length == 1
          codes[3] = signal
          segments[3] = segment
          break
        end
      end
    end

    def decode(output)
      case output.length
      when 2 then return '1'
      when 3 then return '7'
      when 4 then return '4'
      when 7 then return '8'
      when 6 # 0,6,9
        if !output.include?(segments[3])
          return '0'
        elsif !output.include?(segments[2])
          return '6'
        else
          return '9'
        end
      when 5 # 2,3,5
        if !output.include?(segments[5])
          return '2'
        elsif !output.include?(segments[1])
          return '3'
        else
          return '5'
        end
      end

      raise DecodeError, "Could not decode #{output}"
    end
  end
end

class String
  def -(other)
    (self.chars.to_set - other.chars.to_set).to_a.join
  end
end
