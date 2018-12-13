require 'pry'
require_relative 'modules/board_initialization'
require_relative 'modules/board_validator'

class Validator
  include BoardValidator
  include BoardInitialization
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
end
