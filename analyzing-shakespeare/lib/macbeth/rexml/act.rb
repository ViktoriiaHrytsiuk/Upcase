require_relative 'abstract_xml_elements'
require_relative 'scene'

class Act < AbstractXmlElements
  attr_accessor :longest_speech

  def initialize(options = {})
    super(xml_element: options[:act_element])
    @longest_speech = longest_speech
  end

  def max_speech_each_scene
    scene_speeches = {}
    fetch_element("SCENE") do |scene_element|
      scene = Scene.new(scene_element: scene_element)
      scene_title = scene.fetch_element("TITLE")
      scene_speeches[scene_title] = scene.longest_line
    end
    scene_speeches
  end

  def longest_speech
    act_speeches = {}
    scene_longest_line = max_speech_each_scene.values.max_by(&:last)
    scene_title = max_speech_each_scene.key(scene_longest_line)
    act_speeches[scene_title] = scene_longest_line
    act_speeches
  end
end
