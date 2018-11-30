require_relative 'abstract_xml_elements'
require_relative 'act'
require_relative 'elementable'
require 'pry'

class Macbeth < BaseParser
  include Elementable

  def speaker_line_count
    line_count = {}
    speech_iterator do |speech_element|
      speech = Speech.new(speech_element: speech_element)
      speaker_name = speech.xml_block("SPEAKER")
      next if speaker_name == "ALL"
      line_count[speaker_name] = line_count[speaker_name].to_i + speech.lines.count
    end
    line_count
  end

  def speaker_line_length
    line_length = {}
    speech_iterator do |speech_element|
      speech = Speech.new(speech_element: speech_element)
      speaker_name = speech.xml_block("SPEAKER")
      (line_length[speaker_name] ||=[]) << speech.line_length
    end
    line_length
  end

  def speaker_longest_line
    result = {}
    speaker_line_length.each do |speaker, line_length|
      speaker_speech = line_length.map do |each_hash|
        each_hash.max_by{ |text, length| length }
      end
      result[speaker] = speaker_speech.max_by(&:last)
    end
    result
  end

  def longest_line
    speech_length = speaker_longest_line.values.max_by(&:last)
    speaker = speaker_longest_line.key(speech_length)
    speaker + ": " + speech_length.first
  end

  def scene_objects
    scenes = []
    scene_iterator do |scene_element|
      scene = Scene.new(scene_element: scene_element)
      scene.xml_block("TITLE")
      scene.longest_line
      scenes << scene
    end
    scenes
  end

  def scene_object
    max_speech_value = scene_objects.map(&:longest_line).max_by(&:last)
    result_speech_object = nil
    scene_objects.map do |scene|
      if scene.longest_line == max_speech_value
        result_speech_object = scene
      end
    end
    result_speech_object
  end

  def scene_title
    scene_object.xml_block("TITLE") + scene_object.longest_line.first
  end

  def act_objects
    result = []
    act_iterator do |act_element|
      act = Act.new(:act_element => act_element)
      act.xml_block("TITLE")
      act.longest_speech
      result << act
    end
    result
  end

  def act_title
    act_result = act_objects.map(&:longest_speech)

    speech = act_result.map do |each_hash|
      each_hash.values.flatten
    end.max_by(&:last)

    scene_title = act_result.map { |each_hash| each_hash.key(speech) }.compact[0]

    act_title = nil
    act_objects.map do |act|
      act_title = act.xml_block("TITLE") if act.longest_speech.include?(scene_title)
    end

    act = act_title + ". " + scene_title + " "+ speech.first
  end

  private

  def speech_iterator(&block)
    Macbeth.speech_elements(&block)
  end

  def scene_iterator(&block)
    Macbeth.scene_elements(&block)
  end

  def act_iterator(&block)
    Macbeth.act_elements(&block)
  end
end
