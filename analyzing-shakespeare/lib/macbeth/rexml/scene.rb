require_relative 'abstract_xml_elements'
require_relative 'speech'

class Scene < AbstractXmlElements
  attr_accessor :longest_line

  def initialize(options = {})
    super(xml_element: options[:scene_element])
    @longest_line = longest_line
  end

  def speech_length
    result = {}
    xml_block("SPEECH") do |speech_element|
      speech = Speech.new(speech_element: speech_element)
      (result["title"] ||=[] ) << speech.line_length
    end
    result
  end

  def longest_line
    speaker_speech = speech_length["title"].map do |each_hash|
      each_hash.max_by { |text, length| length }
    end
    speaker_speech.max_by(&:last)
  end
end
