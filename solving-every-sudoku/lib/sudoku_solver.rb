require_relative 'sudoku/board'
require 'pry'

class SudokuSolver
  attr_accessor :puzzle_string

  def initialize(puzzle_string)
    @puzzle_string = puzzle_string
  end

  def self.solve(puzzle_string)
    new(puzzle_string).solve
  end

  def board
    @board ||= Board.boards(puzzle_string)
  end

  def empty_position
    index_empty_positions = []
    board.each_with_index do |row, index|
      row.each_with_index do |num, num_index|
        index_empty_positions << [index, num_index] if num == 0
      end
    end
    index_empty_positions
  end

  def empty_positions
    @empty_positions ||= empty_position
  end

  def row_valid?(row, number)
    board[row].each do |row_num|
      return false if row_num == number
    end
  end

  def column_valid?(col, number)
    column_array = board.transpose
    column_array[col].each do |col_num|
      return false if col_num == number
    end
  end

  def box_valid?(row, col, number)
    lower_row = 3 * (row / 3)
    lower_col = 3 * (col / 3)
    upper_row = lower_row + 2
    upper_col = lower_col + 2

    board[lower_row..upper_row].each do |rows|
      rows[lower_col..upper_col].each do |box_num|
        return false if box_num == number
      end
    end
  end

  def valid_board?(row, col, number)
    row_valid?(row, number) &&
      column_valid?(col, number) &&
        box_valid?(row, col, number)
  end

  def solve
    pos_index = 0

    while pos_index < empty_positions.length
      row_index = empty_positions[pos_index][0]
      col_index = empty_positions[pos_index][1]
      possibility = board[row_index][col_index] + 1
      found = false

      while !found && possibility <= 9
        if valid_board?(row_index, col_index, possibility)
          found = true
          board[row_index][col_index] = possibility
          pos_index += 1
        else
          possibility += 1
        end
      end

      if !found
        board[row_index][col_index] = 0
        pos_index -= 1
      end
    end

    board
  end
end
