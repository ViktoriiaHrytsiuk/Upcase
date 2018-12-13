require 'pry'
require 'board'

class Validator
  attr_reader :puzzle_string

  def initialize(puzzle_string)
    @puzzle_string = puzzle_string
  end

  def self.validate(puzzle_string)
    new(puzzle_string).validate
  end

  def validate
    if valid_row? && valid_box? && valid_column? && incomplete?
      "This sudoku is valid, but incomplete."
    elsif invalid?
      "This sudoku is invalid."
    else
      "This sudoku is valid."
    end
  end

  def board
    @board ||= Board.board(puzzle_string)
  end

  def square
    @square ||= Board.new.square(board)
  end

  def valid_row?
    board.all? do |row|
      new_row = row.reject { |i| i == 0 }
      new_row == new_row.uniq
    end
  end

  def valid_column?
    board.transpose.all? do |row|
      new_row = row.reject { |i| i == 0 }
      new_row == new_row.uniq
    end
  end

  def valid_box?
    square.all? do |row|
      new_row = row.reject { |i| i == 0 }
      new_row == new_row.uniq
    end
  end

  def incomplete?
    board.flatten.include?(0)
  end

  def invalid?
    !valid_row? || !valid_box? || !valid_column?
  end
end
