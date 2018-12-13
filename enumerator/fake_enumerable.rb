module FakeEnumerable

  def map
    result = []
    self.each do |item|
      result << yield(item)
    end
    result
  end

  def select
    result = []
    self.each do |item|
      result << item if yield(item)
    end
    result
  end
end
