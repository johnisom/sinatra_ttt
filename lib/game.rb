# frozen_string_literal: true

require_relative 'board'
require_relative 'player'

# Game class that actually plays
class Game
  HUMAN_MARKER = 'x'
  COMPUTER_MARKER = 'o'
  FIRST_TO_MOVE = HUMAN_MARKER
  WIN_MESSAGES = ['Yeah! 1 point up! Keep on going!',
                  "Whoa. You're basically a professional!",
                  'Keep rocking it!'].freeze
  LOSE_MESSAGES = ["I don't care what computer says, I believe in you!",
                   'Keep on going!',
                   "Don't worry, you have totally got this :)",
                   'Is it just me, or are you going to make a comeback?'].freeze
  DRAW_MESSAGES = ['That was a close one!',
                   'You can beat computer next time!',
                   "Computer may be good, but I belive you're better."].freeze

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

  def someone_won_round?
    @board.someone_won?
  end

  def draw?
    @board.full? && !someone_won_round?
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

  def round_winner
    case board.winning_marker
    when human.marker then :human
    when computer.marker then :computer
    else :draw
    end
  end
end
