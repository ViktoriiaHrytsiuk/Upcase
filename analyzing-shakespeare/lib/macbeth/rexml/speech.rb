require_relative 'abstract_xml_elements'

class Speech < AbstractXmlElements
  def initialize(options = {})
    super(xml_element: options[:speech_element])
  end

  def line_length
    length = {}
    fetch_element("LINE").inject(length) do |res, line|
      res[line.text] = line.text.length
      length.merge!(res)
    end
    length
  end
end
