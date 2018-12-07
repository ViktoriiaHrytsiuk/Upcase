require_relative 'sudoku/board'
require 'pry'

class SudokuSolver
  attr_accessor :puzzle_string

  def initialize(puzzle_string)
    @puzzle_string = puzzle_string
    # @board = board_string
  end

  # def self.solve(puzzle_string)
  #   new(puzzle_string).solve
  # end

  def board
    @board ||= Board.new.boards(puzzle_string)
  end

  def empty_positions
    index_empty_positions = []
    board.each_with_index do |row, index|
      row.each_with_index do |num, num_index|
        index_empty_positions << [index, num_index] if num == 0
      end
    end
    index_empty_positions
  end

  def row_valid?
    board.all? do |row|
      new_row = row.reject { |i| i == 0 }
      new_row == new_row.uniq
    end
  end

  def column_valid?
    board.transpose.all? do |row|
      new_row = row.reject { |i| i == 0 }
      new_row == new_row.uniq
    end
  end

  def box_array
    box = []
    board.each_with_index do |row, row_index|
      if row_index % 3 == 0
        row.each_with_index do |col, col_index|
          if col_index % 3 == 0
            square = board[row_index][col_index, 3] + board[row_index + 1][col_index, 3] + board[row_index + 2][col_index, 3]
            box << square
          end
        end
      end
    end
    box
  end

  def box_valid?
    box_array.all? do |row|
      new_row = row.reject { |i| i == 0 }
      new_row == new_row.uniq
    end
  end

  def valid_board?
    box_valid? && row_valid? && column_valid?
  end

  def solve
    pos_index = 0
    while pos_index < empty_positions.length

      row_index = empty_positions[0][0]
      col_index = empty_positions[0][1]
      found = false

      while !found
        (1..9).each do |possibility|
          binding.pry
          board[row_index][col_index] = possibility

          if valid_board?
            pos_index += 1
            found = true
            break
          end

          board[row_index][col_index] = 0
          next
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
