class AbstractXmlElements
  attr_accessor :xml_element

  def initialize(options = {})
    @xml_element = options[:xml_element]
  end

  def grouped_elements
    xml_element.elements.group_by(&:name)
  end

  def xml_block(element_name, &block)
    if block_given?
      grouped_elements[element_name].each(&block)
    else
      grouped_elements[element_name].first.text
    end
  end
end
