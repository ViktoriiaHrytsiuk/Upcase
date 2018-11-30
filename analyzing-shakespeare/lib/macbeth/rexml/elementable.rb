require_relative 'base_parser'

module Elementable
  def self.included(base)
    base.extend MacbethMethods
  end

  module MacbethMethods
    def act_elements(&block)
      BaseParser.rexml_document.elements.each("ACT", &block)
    end

    def scene_elements(&block)
      rexml_document.elements.each("ACT/SCENE", &block)
    end

    def speech_elements(&block)
      BaseParser.rexml_document.elements.each("ACT/SCENE/SPEECH", &block)
    end
  end
end
