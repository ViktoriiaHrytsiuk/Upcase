module TextModificable

  def longest_line
    "#{speech_object.speaker}: #{speech_longest_line.first}"
  end

  def scene_title
    "#{scene_object.title} #{longest_line}"

  end

  def act_title
    "#{act_object.title}. #{scene_title}"
  end
end
