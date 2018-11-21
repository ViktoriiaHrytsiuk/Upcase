require_relative 'scene'

class Speech
  attr_reader :speech_element

  def initialize(speech_element)
    @speech_element = speech_element
  end

  def grouped_element
    speech_element.elements.group_by(&:name)
  end

  def speaker
    grouped_element["SPEAKER"].first.text
  end

  def lines
    grouped_element["LINE"]
  end

  def line_length
    result = {}
    lines.inject(result) do |res, line|
      res[line.text] = line.text.length
      result.merge!(res)
    end
    result
  end
end
