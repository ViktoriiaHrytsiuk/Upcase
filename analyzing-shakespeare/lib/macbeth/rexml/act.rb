require_relative 'scene'

class Act
  attr_accessor :title, :speech, :act_element

  def initialize(options = {})
    @act_element = options[:act_element]
    @title = title
    @speech = max_act_speech
  end

  def grouped_element
    act_element.elements.group_by(&:name)
  end

  def title
    grouped_element["TITLE"].first.text
  end

  def scene_block(&block)
    grouped_element["SCENE"].each(&block)
  end

  def max_speech_each_scene
    scene_speeches = {}
    scene_block do |scene_element|
      scene = Scene.new(:scene_element => scene_element)
      scene_title = scene.title
      scene_speeches[scene_title] = scene.longest_speech
    end
    scene_speeches
  end

  def max_act_speech
    act_speech_title = {}
    act_speech = max_speech_each_scene.values.max_by(&:last)
    scene_title = max_speech_each_scene.key(act_speech)
    act_speech_title[scene_title] = act_speech
    act_speech_title
  end
end
