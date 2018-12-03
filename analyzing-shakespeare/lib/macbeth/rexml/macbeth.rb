require_relative 'abstract_xml_elements'
require_relative 'act'
require_relative 'elementable'
require 'pry'

class Macbeth < BaseParser
  include Elementable

  def speech_objects
    speeches = []
    speech_iterator do |speech_element|
      speech = Speech.new(speech_element: speech_element)
      speech.speaker
      speech.line_count
      speech.line_length
      speeches << speech
    end
    speeches
  end

  def speaker_line_count
    line_count = {}
    speech_objects.map do |speech|
      speaker_name = speech.speaker
      next if speaker_name == "ALL"
      lines_count = speech.line_count
      line_count[speaker_name] = line_count[speaker_name].to_i + lines_count
    end
    line_count
  end

  def speech_object
    lines = speech_objects.map(&:line_length)
    longest_line = lines.max_by(&:last)

    speech_objects.map do |speech|
      return speech if speech.line_length == longest_line
    end
  end

  def speech_longest_line
    speech_object.line_length
  end

  def speaker_longest_line
    speech_object.speaker + ": " + longest_line.first
  end

  def scene_objects
    scenes = []
    scene_iterator do |scene_element|
      scene = Scene.new(scene_element: scene_element)
      scene.title
      scene.longest_line
      scenes << scene
    end
    scenes
  end

  def scene_object
    longest_line = speech_longest_line

    scene_objects.map do |scene|
      return scene if scene.longest_line == longest_line
    end
  end

  def scene_title
    scene_object.title + scene_object.longest_line.first
  end

  def act_objects
    result = []
    act_iterator do |act_element|
      act = Act.new(:act_element => act_element)
      act.title
      act.longest_speech
      result << act
    end
    result
  end

  def act_object
    longest_line = speech_longest_line

    act_objects.map do |act|
      return act if act.longest_speech.has_value?(longest_line)
    end
  end

  def act_title
    act_object.title + act_object.longest_speech.keys.join + act_object.longest_speech.values.flatten.first
  end
end
