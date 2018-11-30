require_relative 'abstract_xml_elements'
require_relative 'scene'

class Act < AbstractXmlElements
  attr_accessor :speech

  def initialize(options = {})
    super(xml_element: options[:act_element])
    @speech = max_act_speech
  end

  def max_speech_each_scene
    scene_speeches = {}
    xml_block("SCENE") do |scene_element|
      scene = Scene.new(scene_element: scene_element)
      scene_title = scene.xml_block("TITLE")
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
