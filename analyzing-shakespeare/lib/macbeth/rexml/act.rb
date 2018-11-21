require_relative 'scene'

class Act
  attr_accessor :title, :scene, :speech, :act_element

  def initialize(options = {})
    @act_element = options[:act_element]
    @title = title
    @scene = max_speech_each_scene
    @speech = max_scene_speech
  end

  def grouped_element
    act_element.elements.group_by(&:name)
  end

  def title
    grouped_element["TITLE"].first.text
  end

  def max_speech_each_scene
    scene_speeches = []
    grouped_element["SCENE"].each do |scene_element|
      @scene = Scene.new(:scene_element => scene_element)
      scene_speeches << @scene.longest_speech
    end
    scene_speeches
  end

  def max_scene_speech
    max_speech_each_scene.max_by(&:last)
  end
end
