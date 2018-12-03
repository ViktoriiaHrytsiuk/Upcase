require_relative 'base_parser'

module Elementable
  def self.included(base)
    base.extend MacbethMethods
  end

  def speech_iterator(&block)
    Macbeth.speech_elements(&block)
  end

  def scene_iterator(&block)
    Macbeth.scene_elements(&block)
  end

  def act_iterator(&block)
    Macbeth.act_elements(&block)
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
