class ResultObject
  attr_accessor :lines_count, :longest_line, :scene_name

  def initialize
    @lines_count = {}
    @longest_line = []
    @scene_name = []
  end
end
