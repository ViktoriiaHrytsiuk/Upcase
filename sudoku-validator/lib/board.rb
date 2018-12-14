class Board
  def self.board(puzzle_string)
    board = []
    puzzle_string.each_line do |line|
      array = line.scan(/\d/).map(&:to_i)
      board << array if array.size == 9
    end
    board
  end

  def self.square(board)
    first_indexes = [0,3,6]
    squares = []
    board.each_with_index do |row, index|
      if first_indexes.include?(index)
        first_indexes.inject(squares) do |box, items|
          box = board[index][items, 3] + board[index + 1][items, 3] + board[index + 2][items, 3]
          (squares ||= []) << box
        end
      end
    end
    squares
  end
end
