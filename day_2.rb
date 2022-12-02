# Computes scores from rock paper scissors game according to aoc-2022's specifications
# https://adventofcode.com/2022/day/2

class RPS
  WINNING_SHAPES = {
    rock: :paper,
    paper: :scissors,
    scissors: :rock
  }.freeze

  # Formats raw input into an array of 'rounds'
  def initialize(guide)
    @guide = guide.split("\n")
                  .map(&:split)
  end

  # Returns the total score from all the rounds
  # Decrypts the guide, then adds up the score from each round
  def tournament_score(part:)
    decrypted_guide = if part == 1
                        decrypt_all(part: 1)
                      else
                        decrypt_all(part: 2)
                      end
    decrypted_guide.map { |shape_pair| round_score(shape_pair) }.sum
  end

  # Returns the score for a single round
  def round_score(shapes)
    shape_score(shapes) + outcome_score(shapes)
  end

  # Returns the sub-score based on the player's shape in a round
  def shape_score(shapes)
    case shapes.last
    when :rock  then 1
    when :paper then 2
    else             3
    end
  end

  # Returns the sub-score based on the outcome of the round
  def outcome_score(shapes)
    opponent_move = shapes.first
    player_move = shapes.last
    if WINNING_SHAPES[opponent_move] == player_move
      6
    elsif shapes.first == shapes.last
      3
    else
      0
    end
  end

  # Convert all the rows in the guide into moves
  def decrypt_all(part:)
    if part == 1
      @guide.map { |row| [decrypt_opponent(row), decrypt_player_part_one(row)] }
    else
      @guide.map { |row| [decrypt_opponent(row), decrypt_player_part_two(row)] }
    end
  end

  # 'A', 'B', and 'C' will always refer to the opponent's move
  def decrypt_opponent(row)
    case row.first
    when 'A' then :rock
    when 'B' then :paper
    else          :scissors
    end
  end

  # In part 1, the symbol refers to the shape you should pick
  def decrypt_player_part_one(row)
    case row.last
    when 'X' then :rock
    when 'Y' then :paper
    else          :scissors
    end
  end

  # In part 2, the symbol refers to the desired outcome of the match
  def decrypt_player_part_two(row)
    opponent_move = decrypt_opponent(row)
    case row.last
    when 'X'
      WINNING_SHAPES.each do |losing_move, winning_move|
        return losing_move if opponent_move == winning_move
      end
    when 'Y' then opponent_move
    when 'Z' then WINNING_SHAPES[opponent_move]
    end
  end
end

guide = File.read('input/day_2.txt')
rps = RPS.new(guide)
puts "Your total score in part 1 is #{rps.tournament_score(part: 1)}."
puts "Your total score in part 2 is #{rps.tournament_score(part: 2)}."
