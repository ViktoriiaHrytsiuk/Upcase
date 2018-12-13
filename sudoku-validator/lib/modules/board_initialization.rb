require_relative '../board'

module BoardInitialization
  def board
    @board ||= Board.board(puzzle_string)
  end

  def square
    @square ||= Board.square(board)
  end
end
