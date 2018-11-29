require 'rexml/document'
require_relative '../base_request'

class BaseParser

  def rexml_document
    REXML::Document.new(BaseRequest.fetch_xml).root
  end
end
