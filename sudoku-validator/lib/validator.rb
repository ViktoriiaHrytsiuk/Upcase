require 'pry'

class Validator
  def initialize(puzzle_string)
    @puzzle_string = puzzle_string
  end

  def self.validate(puzzle_string)
    new(puzzle_string).validate
  end

  def validate
    puzzle_array = []
    @puzzle_string.each_line do |line|
      array = line.scan(/\d/).map(&:to_i)
      puzzle_array << array if array.size == 9
    end
    puzzle_array

    column_array = puzzle_array.transpose

    box_array = []
    puzzle_array.each_with_index do |row, row_index|
      if row_index % 3 == 0
        row.each_with_index do |col, col_index|
          if col_index % 3 == 0
            square = puzzle_array[row_index][col_index, 3] + puzzle_array[row_index + 1][col_index, 3] + puzzle_array[row_index + 2][col_index, 3]
            box_array << square
          end
        end
      end
    end
    box_array

    valid_row = puzzle_array.all? do |row|
      new_row = row.reject { |i| i == 0 }
      new_row.uniq == new_row
    end

    valid_column = column_array.all? do |row|
      new_row = row.reject { |i| i == 0 }
      new_row.uniq == new_row
    end

    valid_box = box_array.all? do |row|
      new_row = row.reject { |i| i == 0 }
      new_row.uniq == new_row
    end

    incomplete = puzzle_array.flatten.include?(0)
    invalid = !valid_row || !valid_box || !valid_column

    if valid_row && incomplete && valid_box && valid_column
      "This sudoku is valid, but incomplete."
    elsif invalid
      "This sudoku is invalid."
    else
      "This sudoku is valid."
    end
  end
end
