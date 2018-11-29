require_relative 'abstract_xml_elements'

class Speech < AbstractXmlElements
  def initialize(options = {})
    super(xml_element: options[:speech_element])
  end

  def lines
    grouped_elements["LINE"]
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
