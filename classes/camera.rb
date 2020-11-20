class Camera

  attr_accessor :width, :height, :pos

  def initialize(width: 1280, height: 720, pos: Vec3.new)
    @width = width
    @height = height
    @pos = pos
  end

  def numPixels
    (@width * @height)
  end

end
