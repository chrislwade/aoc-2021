require 'day'
require 'set'

class Day21 < Day
  def self.sample
    {puzzle1: 739785, puzzle2: 444356092776315}
  end

  def self.expected
    {puzzle1: 679329, puzzle2: 433315766324816}
  end

  def display
    puts "--- Day 21: Dirac Dice ---"
    puts "What do you get if you multiply the score of the losing player by the number of times the die was rolled during the game?"
    puts "- Puzzle 1: #{puzzle1}"
    puts "Find the player that wins in more universes; in how many universes does that player win?"
    puts "- Puzzle 2: #{puzzle2}"
  end

  def puzzle1
    die = DeterministicDie.new(100)
    players = initial_positions.map.with_index {|position, id| Player.new(id + 1, position) }

    until players.any? {|player| player.score >= 1000}
      player = players.shift

      player.position += die.roll + die.roll + die.roll
      player.score += (player.position - 1) % 10 + 1

      players.push(player)
    end

    players.map(&:score).min * die.rolls
  end

  def puzzle2
    games = Hash.new(0)
    games[initial_positions.map {|position| [position, 0]}] = 1
    wins = [0, 0]

    until games.empty?
      round = games.clone
      games = Hash.new(0)
      round.each do |state, universes|
        ((p1p, p1s), (p2p, p2s)) = *state

        frequencies.each do |roll, frequency|
          p1u = universes * frequency
          np1p = (p1p + roll - 1) % 10 + 1
          np1s = p1s + np1p

          if np1s >= 21
            wins[0] += p1u
          else
            frequencies.each do |roll, frequency|
              p2u = p1u * frequency
              np2p = (p2p + roll - 1) % 10 + 1
              np2s = p2s + np2p

              if np2s >= 21
                wins[1] += p2u
              else
                games[[[np1p, np1s], [np2p, np2s]]] += p2u
              end
            end
          end
        end
      end
    end

    wins.max
  end

  protected

  def initial_positions
    lines.map(&:split).map(&:last).map(&:to_i)
  end

  def frequencies
    @frequencies ||= Hash.new(0).tap do |f|
      (1..3).each {|i| (1..3).each {|j| (1..3).each {|k| f[i+j+k] += 1}}}
    end
  end

  class Player
    attr_accessor :id, :position, :score

    def initialize(id, position)
      self.id       = id
      self.position = position
      self.score    = 0
    end
  end

  class Die
    attr_accessor :sides, :rolls

    def initialize(sides)
      self.sides = sides
      self.rolls = 0
    end

    def roll
      self.rolls += 1
      rand(1..sides)
    end
  end

  class DeterministicDie < Die
    def roll
      super
      (rolls - 1) % sides + 1
    end
  end
end
