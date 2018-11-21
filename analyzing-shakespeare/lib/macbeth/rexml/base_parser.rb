require 'rexml/document'
require_relative '../base_request'

class BaseParser < BaseRequest

  def rexml_document
    REXML::Document.new(macbeth_xml).root
  end
end
