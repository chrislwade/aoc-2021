require 'day'
require 'pry'

class Day16 < Day
  def self.sample
    {puzzle1: 31, puzzle2: :skipped}
  end

  def self.expected
    {puzzle1: 847, puzzle2: 333794664059}
  end

  def display
    puts "--- Day 16: Packet Decoder ---"
    puts "What do you get if you add up the version numbers in all packets?"
    puts "- Puzzle 1: #{puzzle1}"
    puts "What do you get if you evaluate the expression represented by your hexadecimal-encoded BITS transmission?"
    puts "- Puzzle 2: #{puzzle2}"
  end

  def puzzle1
    Packet.new(lines.first).versions.sum
  end

  def puzzle2
    Packet.new(lines.first).evaluate
  end

  class Packet
    attr_accessor :bits, :version, :type_id, :value, :packets

    def initialize(input, format: :hex)
      self.bits = format == :hex ? convert(input) : input
      self.packets = []
      parse!
    end

    def versions
      all_packets.map(&:version)
    end

    def evaluate
      values = packets.map(&:evaluate)
      case type_id
      when 0 then values.sum
      when 1 then values.reduce(1, :*)
      when 2 then values.min
      when 3 then values.max
      when 4 then value
      when 5 then values.first > values.last ? 1 : 0
      when 6 then values.first < values.last ? 1 : 0
      when 7 then values.first == values.last ? 1 : 0
      end
    end


    def all_packets
      (packets.nil? ? [self] : [packets.map(&:all_packets)] + [self]).flatten
    end

    protected

    def convert(input)
      input.chars.map{|c| c.to_i(16).to_s(2).rjust(4, '0')}.join
    end

    def parse!
      self.version = read_int!(3)
      self.type_id = read_int!(3)

      if type_id == 4
        parse_literal!
      else
        if read_bit! == 0
          sub_packet_bit_length = read_int!(15)
          sub_packet_bits = bits.slice!(0, sub_packet_bit_length)
          until sub_packet_bits.empty?
            packets.push(self.class.new(sub_packet_bits, format: :bits))
          end
        else
          sub_packet_count = read_int!(11)
          sub_packet_count.times do
            packets.push(self.class.new(bits, format: :bits))
          end
        end
      end
    end

    def parse_literal!
      parts = []
      loop do
        marker = read_bit!
        parts.push(read_bits!(4))
        break if marker == 0
      end
      self.value = parts.join.to_i(2)
    end

    def align!
      read_bits!(bits.length % 4) if bits.length % 4 > 0
    end

    def read_bits!(count)
      bits.slice!(0, count)
    end

    def read_bit!
      read_bits!(1).to_i(2)
    end

    def read_int!(count)
      read_bits!(count).to_i(2)
    end
  end
end
