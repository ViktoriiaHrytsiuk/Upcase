require_relative 'fake_enumerable'

class FakeArrayWrapper
  include FakeEnumerable

  def initialize(*args)
    @fake_array = args.flatten
  end

  def each(&block)
    @fake_array.each(&block)
    self
  end
end
