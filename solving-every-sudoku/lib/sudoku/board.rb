class Board
  attr_accessor :board

  def initialize
    @board = []
  end

  def boards(puzzle_string)
    puzzle_string.each_line do |line|
      array = line.scan(/\d/).map(&:to_i)
      board << array if array.size == 9
    end
    board
  end

  # def [](x, y)
  #   @board[y][x]
  # end

  # def []=(x, y, value)
  #   @board[y][x] = value
  # end

  # def row(y)
  #   Array.new(@board[y])
  # end



end
