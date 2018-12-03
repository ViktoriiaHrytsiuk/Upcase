require_relative 'abstract_xml_elements'

class Speech < AbstractXmlElements
  attr_accessor :speaker, :line_count, :line_length

  def initialize(options = {})
    super(xml_element: options[:speech_element])
    @speaker = speaker
    @line_count = line_count
    @line_length = line_length
  end

  def line_length
    length = {}
    fetch_element("LINE").inject(length) do |res, line|
      res[line.text] = line.text.length
      length.merge!(res)
    end
    length.max_by(&:last)
  end

  def line_count
    fetch_element("LINE").count
  end

  def speaker
    fetch_element("SPEAKER").first.text
  end
end
