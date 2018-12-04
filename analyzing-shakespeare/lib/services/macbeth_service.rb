require_relative '../modules/elementable'
require_relative '../macbeth/rexml/act'

class MacbethService
  include Elementable

  attr_accessor :speeches, :scenes, :acts

  def initialize
    @speeches = []
    @scenes = []
    @acts = []
  end

  def speeches
    speech_iterator do |speech_element|
      speech = Speech.new(speech_element: speech_element)
      speech.speaker
      speech.line_count
      speech.line_length
      @speeches << speech
    end
    @speeches
  end

  def scenes
    scene_iterator do |scene_element|
      scene = Scene.new(scene_element: scene_element)
      scene.title
      scene.longest_line
      @scenes << scene
    end
    @scenes
  end

  def acts
    act_iterator do |act_element|
      act = Act.new(:act_element => act_element)
      act.title
      act.longest_speech
      @acts << act
    end
    @acts
  end
end
