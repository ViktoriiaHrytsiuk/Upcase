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
    if valid_row && incomplete && valid_box && valid_column
      "This sudoku is valid, but incomplete."
    elsif invalid
      "This sudoku is invalid."
    else
      "This sudoku is valid."
    end
  end

  def board
    @board ||= Board.board(puzzle_string)
  end

  def valid_row
    board.all? do |row|
      new_row = row.reject { |i| i == 0 }
      new_row.uniq == new_row
    end
  end

  def valid_column
    board.transpose.all? do |row|
      new_row = row.reject { |i| i == 0 }
      new_row.uniq == new_row
    end
  end

  def small_board
    box_array = []
    board.each_with_index do |row, row_index|
      if row_index % 3 == 0
        row.each_with_index do |col, col_index|
          if col_index % 3 == 0
            square = board[row_index][col_index, 3] + board[row_index + 1][col_index, 3] + board[row_index + 2][col_index, 3]
            box_array << square
          end
        end
      end
    end
    box_array
  end

  def valid_box
    small_board.all? do |row|
      new_row = row.reject { |i| i == 0 }
      new_row.uniq == new_row
    end
  end

  def incomplete
    incomplete = board.flatten.include?(0)
  end

  def invalid
    invalid = !valid_row || !valid_box || !valid_column
  end
end
