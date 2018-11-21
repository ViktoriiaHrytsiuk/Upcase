require_relative 'scene'

class Act
  attr_accessor :title, :scene, :speech, :act_element

  def initialize(options = {})
    @act_element = options[:act_element]
    @title = title
    @scene = scene_speech
    @speech = options[:speech]
  end

  def grouped_element
    act_element.elements.group_by(&:name)
  end

  def title
    grouped_element["TITLE"].first.text
  end

  def scene_speech
    scene_object = []
    grouped_element["SCENE"].each do |scene_element|
      @scene = Scene.new(:scene_element => scene_element)
      scene_object << @scene.longest_speech
    end
    scene_object
  end
end
