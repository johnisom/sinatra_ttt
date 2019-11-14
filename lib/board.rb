# frozen_string_literal: true

require_relative 'square'

# Board class to represent
class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9], # rows
                   [1, 4, 7], [2, 5, 8], [3, 6, 9], # columns
                   [1, 5, 9], [3, 5, 7]].freeze     # diagonals

  attr_reader :squares

  def initialize
    @squares = {}
    reset
  end

  def reset
    1.upto(9) { |key| @squares[key] = Square.new }
  end

  def []=(key, marker)
    @squares[key].marker = marker
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !winning_marker.nil?
  end

  def best_move(markers)
    return best_square(markers[0]) unless best_square(markers[0]).nil?
    return best_square(markers[1]) unless best_square(markers[1]).nil?
    return 5 if @squares[5].unmarked?

    unmarked_keys.sample
  end

  # return winning marker or nil
  def winning_marker
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      markers = squares.map(&:marker)
      return markers[0] if markers.uniq.size == 1 && squares[0].marked?
    end
    nil
  end

  def best_square(marker)
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      markers = squares.map(&:marker)
      if squares.one?(&:unmarked?) && markers.count(marker) == 2
        return line[squares.index(&:unmarked?)]
      end
    end
    nil
  end
end
