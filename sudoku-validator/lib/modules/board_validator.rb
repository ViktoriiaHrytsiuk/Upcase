module BoardValidator
  def valid_row?
    board.all? do |row|
      new_row = row.reject { |i| i == 0 }
      new_row == new_row.uniq
    end
  end

  def valid_column?
    board.transpose.all? do |row|
      new_row = row.reject { |i| i == 0 }
      new_row == new_row.uniq
    end
  end

  def valid_box?
    square.all? do |row|
      new_row = row.reject { |i| i == 0 }
      new_row == new_row.uniq
    end
  end

  def incomplete?
    board.flatten.include?(0)
  end

  def invalid?
    !valid_row? || !valid_box? || !valid_column?
  end
end
