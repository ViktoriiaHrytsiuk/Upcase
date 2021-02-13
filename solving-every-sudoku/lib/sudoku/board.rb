class Board

  def self.boards(puzzle_string)
    board = []
    puzzle_string.each_line do |line|
      array = line.scan(/\d/).map(&:to_i)
      board << array if array.size == 9
    end
    board
  end
end
