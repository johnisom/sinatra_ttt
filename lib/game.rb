require_relative 'board'
require_relative 'player'

# Game class that actually plays
class Game
  HUMAN_MARKER = 'x'.freeze
  COMPUTER_MARKER = 'o'.freeze
  FIRST_TO_MOVE = HUMAN_MARKER

  attr_reader :board, :human, :computer

  def initialize
    @board = Board.new
    @human = Player.new(HUMAN_MARKER)
    @computer = Player.new(COMPUTER_MARKER)
    @current_marker = FIRST_TO_MOVE
  end

  def someone_won?
    human.score == 5 || computer.score == 5
  end

  def current_player_moves
    if human_turn?
      human_moves
      @current_marker = computer.marker
    else
      computer_moves
      @current_marker = human.marker
    end
  end

  def human_turn?
    @current_marker == human.marker
  end

  def reset_round
    board.reset
    @current_marker = FIRST_TO_MOVE
  end

  def reset_game
    reset_round
    human.score = 0
    computer.score = 0
  end

  def human_moves(square)
    board[square] = human.marker
  end

  def computer_moves
    board[board.best_move([computer.marker, human.marker])] = computer.marker
  end

  def give_point
    case board.winning_marker
    when human.marker    then human.score += 1
    when computer.marker then computer.score += 1
    end
  end
end
