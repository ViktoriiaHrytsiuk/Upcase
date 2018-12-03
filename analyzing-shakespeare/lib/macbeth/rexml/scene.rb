require_relative 'abstract_xml_elements'
require_relative 'speech'

class Scene < AbstractXmlElements
  attr_accessor :longest_line, :title

  def initialize(options = {})
    super(xml_element: options[:scene_element])
    @longest_line = longest_line
    @title = title
  end

  def title
    fetch_element("TITLE").first.text
  end

  def speech_line_length
    result = {}
    fetch_element("SPEECH") do |speech_element|
      speech = Speech.new(speech_element: speech_element)
      (result["title"] ||=[] ) << speech.line_length
    end
    result
  end

  def longest_line
    speech_line_length['title'].max_by(&:last)
  end
end
