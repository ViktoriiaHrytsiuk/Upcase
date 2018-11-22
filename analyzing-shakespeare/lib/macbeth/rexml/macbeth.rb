require_relative 'base_parser'
require_relative 'scene'
require_relative 'act'

class Macbeth < BaseParser
  def speaker_line
    speaker_lines = {}
    speech_elements do |speech_element|
      speech = Speech.new(speech_element)
      next if speech.speaker == "ALL"
      speaker_lines[speech.speaker] = speaker_lines[speech.speaker].to_i + speech.lines.count
    end
    speaker_lines
  end

  def longest_line
    text_length = {}
    speech_elements do |speech_element|
      speech = Speech.new(speech_element)
      (text_length[speech.speaker] ||=[]) << speech.line_length
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
    result = []
    act_elements do |act_element|
      @act = Act.new(:act_element => act_element)
      @act.title
      @act.speech
      result << @act
    end
    act_object(result)
  end

  def act_object(result)
    act_result = result.map(&:speech)

    speech = act_result.map do |each_hash|
      each_hash.values.flatten
    end.max_by(&:last)

    scene_title = act_result.map { |each_hash| each_hash.key(speech) }.compact[0]

    act_title = nil
    result.map do |act|
      act_title = act.title if act.speech.include?(scene_title)
    end
    act_title + ". " + scene_title + speech.first
  end

  def scene_objects
    scenes = []
    scene_elements do |scene_element|
      @scene = Scene.new(:scene_element => scene_element)
      @scene.title
      @scene.max_scene_line
      scenes << @scene
    end
    title(scenes)
  end

  def title(scenes)
    max_speech_value = scenes.map(&:longest_speech).max_by(&:last)

    result_speech_object = nil
    scenes.map do |scene|
      if scene.longest_speech == max_speech_value
        result_speech_object = scene
      end
    end
    scene_name(result_speech_object)
  end

  def scene_name(speech_object)
    speech_object.title + speech_object.longest_speech.first
  end

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
