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
    box_array = []
    board.each_with_index do |row, row_index|
      if row_index % 3 == 0
        row.each_with_index do |num, index|
          if index % 3 == 0
            squares = board[row_index][index, 3] + board[row_index + 1][index, 3] + board[row_index + 2][index, 3]
            box_array << squares
          end
        end
      end
    end
    box_array
  end
end
