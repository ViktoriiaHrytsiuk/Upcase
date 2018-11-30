require_relative 'abstract_xml_elements'

class Speech < AbstractXmlElements
  def initialize(options = {})
    super(xml_element: options[:speech_element])
  end

  def lines
    grouped_elements["LINE"]
  end

  def line_length
    length = {}
    lines.inject(length) do |res, line|
      res[line.text] = line.text.length
      length.merge!(res)
    end
    length
  end
end
