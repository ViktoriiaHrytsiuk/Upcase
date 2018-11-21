require 'pry'
require_relative 'speech'

class Scene
  attr_accessor :scene_element, :title, :longest_speech

  def initialize(options = {})
    @scene_element = options[:scene_element]
    @title = title
    @longest_speech = max_scene_line
  end

  def grouped_elements
    scene_element.elements.group_by(&:name)
  end

  def title
    grouped_elements["TITLE"].first.text
  end

  def speech_block(&block)
    grouped_elements["SPEECH"].each(&block)
  end

  def speech_line
    result = {}
    speech_block do |speech_element|
      speech = Speech.new(speech_element)
      (result["title"] ||=[] ) << speech.line_length
    end
    result
  end

  def max_scene_line
    speaker_speech = speech_line["title"].map do |each_hash|
      each_hash.max_by{ |text, length| length }
    end
    speaker_speech.max_by(&:last)
  end
end
