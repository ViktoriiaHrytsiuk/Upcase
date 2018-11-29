require_relative 'abstract_xml_elements'
require_relative 'base_parser'
require_relative 'act'
require_relative 'scene'
require_relative 'speech'

require 'pry'

class Macbeth < BaseParser
  def speaker_line
    line_count = {}
    speech_elements do |speech_element|
      binding.pry

      speech = Speech.new(speech_element: speech_element)
      speaker_name = speech.xml_block("SPEAKER")
      next if speaker_name == "ALL"
      line_count[speaker_name] = line_count[speaker_name].to_i + speech.lines.count
    end
    line_count
  end

  def longest_line
    text_length = {}
    speech_elements do |speech_element|
      speech = Speech.new(speech_element: speech_element)
      speaker_name = speech.xml_block("SPEAKER")
      (text_length[speaker_name] ||=[]) << speech.line_length
    end
    speaker_speech(text_length)
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
    result = {}
    act_elements do |act_element|
      act = Act.new(act_element: act_element)
      title = act.xml_block("TITLE")

      scene_block = {}
      act.xml_block("SCENE") do |scene|
        grouped_elements = scene.elements.group_by(&:name)
        scene_name = grouped_elements["TITLE"].first.text
        speech_block = grouped_elements["SPEECH"]
        scene_block[scene_name] = speech_block
      end
      scene_block
      result[title] = scene_block
    end
    result
  end

  # def max_act_speech
  #   scene_speeches = {}
  #   scene_elements do |scene_element|
  #     scene = Scene.new(scene_element: scene_element)
  #     scene_title = scene.xml_block("TITLE")
  #     scene_speeches[scene_title] = scene.longest_speech
  #   end
  #   scene_speeches

  #   act_speech_title = {}
  #   act_speech = scene_speeches.values.max_by(&:last)
  #   scene_title = scene_speeches.key(act_speech)
  #   act_speech_title[scene_title] = act_speech
  # end

  # def act_object(result)
  #   act_result = result.map(&:speech)

  #   speech = act_result.map do |each_hash|
  #     each_hash.values.flatten
  #   end.max_by(&:last)

  #   scene_title = act_result.map { |each_hash| each_hash.key(speech) }.compact[0]

  #   act_title = nil
  #   result.map do |act|
  #     act_title = act.title if act.speech.include?(scene_title)
  #   end
  #   act_title + ". " + scene_title + speech.first
  # end

  # def scene_objects
  #   scenes = []
  #   scene_elements do |scene_element|
  #     @scene = Scene.new(scene_element: scene_element)
  #     @scene.title
  #     @scene.max_scene_line
  #     scenes << @scene
  #   end
  #   title(scenes)
  # end

  # def title(scenes)
  #   max_speech_value = scenes.map(&:longest_speech).max_by(&:last)

  #   result_speech_object = nil
  #   scenes.map do |scene|
  #     if scene.longest_speech == max_speech_value
  #       result_speech_object = scene
  #     end
  #   end
  #   scene_name(result_speech_object)
  # end

  # def scene_name(speech_object)
  #   speech_object.title + speech_object.longest_speech.first
  # end

  private

  def act_elements(&block)
    rexml_document.elements.each("ACT", &block)
  end

  def scene_elements(&block)
    rexml_document.elements.each("ACT/SCENE", &block)
  end

  def speech_elements(&block)
    rexml_document.elements.each("ACT/SCENE/SPEECH", &block)
  end
end
