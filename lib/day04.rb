require 'day'
require 'matrix'

class Day04 < Day
  def self.expected
    {puzzle1: 4512, puzzle2: 1924}
  end

  def display
    puts "--- Day 04: Giant Squid ---"
    puts "What will your final score be if you choose that board?"
    puts "- Puzzle 1: #{puzzle1}"
    puts "Once it wins, what would its final score be?"
    puts "- Puzzle 2: #{puzzle2}"
  end

  def puzzle1
    setup!
    play!
    winning_boards.first.final_score
  end

  def puzzle2
    setup!
    play!
    winning_boards.last.final_score
  end

  protected

  attr_accessor :moves, :boards
  attr_accessor :winning_boards

  STATE_INIT          = 0
  STATE_MOVES_LOADED  = 1
  STATE_BOARD_LOADING = 2
  STATE_BOARD_LOADED  = 3

  def setup!
    self.boards = []
    state = STATE_INIT

    lines.each do |line|
      case state
      when STATE_INIT
        self.moves = line.split(',').map(&:to_i)
        state = STATE_MOVES_LOADED

      when STATE_MOVES_LOADED, STATE_BOARD_LOADED
        if line.empty?
          next
        end
        boards.push([line.split(' ')])
        state = STATE_BOARD_LOADING

      when STATE_BOARD_LOADING
        if line.empty?
          state = STATE_BOARD_LOADED
        else
          boards.last.push(line.split(' '))
        end
      end
    end

    boards.map! {|board| Board.new(board)}
  end

  def play!
    self.winning_boards = []

    moves.each do |move|
      boards.each do |board|
        board.mark!(move)
        if board.won? && !winning_boards.include?(board)
          winning_boards.push(board)
        end
      end
    end
  end

  class Board
    attr_accessor :values, :board
    attr_accessor :rows, :columns
    attr_accessor :move

    def initialize(board)
      board = board.map do |row|
        row.map {|column| Value.new(column.to_i)}
      end
      self.values = board.flatten
      self.board = Matrix[*board]
    end

    def mark!(number)
      if won?
        return
      end

      value = values.find {|value| value.number == number}
      if !value.nil?
        value.mark!
        self.move = number
      end
    end

    def won?
      board.column_vectors.any? {|column| column.all?(&:marked?)} ||
        board.row_vectors.any? {|row| row.all?(&:marked?)}
    end

    def final_score
      values.reject(&:marked?).sum(&:number) * move
    end

    class Value
      attr_accessor :number, :marked

      def initialize(number)
        self.number = number
        self.marked = false
      end

      def mark!
        self.marked = true
      end

      def marked?
        self.marked
      end
    end
  end
end