require_relative '../services/macbeth_service'
require_relative 'result_object'
require_relative '../modules/text_modificable'
require 'pry'

class Macbeth
  include TextModificable

  def speaker_line_count
    macbeth_service_object.speeches.map do |speech|
      speaker_name = speech.speaker
      next if speaker_name == "ALL"
      result_object.lines_count[speaker_name] = result_object.lines_count[speaker_name].to_i +       speech.line_count
    end
    result_object.lines_count
  end

  def speech_object
    longest_line = macbeth_service_object.speeches.map(&:line_length).max_by(&:last)

    macbeth_service_object.speeches.map do |speech|
      return speech if speech.line_length == longest_line
    end
  end

  def speech_longest_line
    result_object.longest_line = speech_object.line_length
  end

  def scene_object
    longest_line = speech_longest_line
    macbeth_service_object.scenes.map do |scene|
      return scene if scene.longest_line == longest_line
    end
  end

  def act_object
    longest_line = speech_longest_line

    macbeth_service_object.acts.map do |act|
      return act if act.longest_speech.has_value?(longest_line)
    end
  end

  def result_object
    @result_object ||= ResultObject.new
  end

  def macbeth_service_object
    @macbeth_service ||= MacbethService.new
  end
end
