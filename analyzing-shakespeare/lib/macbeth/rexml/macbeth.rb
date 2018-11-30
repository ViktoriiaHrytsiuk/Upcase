require_relative 'abstract_xml_elements'
require_relative 'act'
require_relative 'elementable'
require 'pry'

class Macbeth < BaseParser
  include Elementable

  def speaker_line
    line_count = {}
    Macbeth.speech_elements do |speech_element|
      speech = Speech.new(speech_element: speech_element)
      speaker_name = speech.xml_block("SPEAKER")
      next if speaker_name == "ALL"
      line_count[speaker_name] = line_count[speaker_name].to_i + speech.lines.count
    end
    line_count
  end

  def speaker_lines_length
    line_length = {}
    Macbeth.speech_elements do |speech_element|
      speech = Speech.new(speech_element: speech_element)
      speaker_name = speech.xml_block("SPEAKER")
      (line_length[speaker_name] ||=[]) << speech.line_length
    end
    # line_length
    speaker_speech(line_length)
  end

  def speaker_speech(speaker_text)
    speech = {}
    speaker_text.each do |speaker, line_length|
      speaker_speech = line_length.map do |each_hash|
        each_hash.max_by{ |text, length| length }
      end
      speech[speaker] = speaker_speech.max_by(&:last)
    end
    longest_speeches(speech)
  end

  def longest_speeches(speech)
    speech_length = speech.values.max_by(&:last)
    speaker = speech.key(speech_length)
    speaker + ": " + speech_length.first
  end

  def act_iterator
    result = []
    Macbeth.act_elements do |act_element|
      act = Act.new(:act_element => act_element)
      act.xml_block("TITLE")
      act.longest_speech
      result << act
    end
    act_object(result)
  end

  def act_object(result)
    act_result = result.map(&:longest_speech)

    speech = act_result.map do |each_hash|
      each_hash.values.flatten
    end.max_by(&:last)

    scene_title = act_result.map { |each_hash| each_hash.key(speech) }.compact[0]

    act_title = nil
    result.map do |act|
      act_title = act.xml_block("TITLE") if act.longest_speech.include?(scene_title)
    end
    act = act_title + ". " + scene_title + " "+ speech.first
  end

  def scene_objects
    scenes = []
    Macbeth.scene_elements do |scene_element|
      scene = Scene.new(scene_element: scene_element)
      scene.xml_block("TITLE")
      scene.longest_line
      scenes << scene
    end
    title(scenes)
  end

  def title(scenes)
    max_speech_value = scenes.map(&:longest_line).max_by(&:last)
    result_speech_object = nil
    scenes.map do |scene|
      if scene.longest_line == max_speech_value
        result_speech_object = scene
      end
    end
    scene_name(result_speech_object)
  end

  def scene_name(speech_object)
    speech_object.xml_block("TITLE") + speech_object.longest_line.first
  end
end
