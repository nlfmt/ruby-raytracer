class Light

  attr_accessor :p, :color, :strength

  def initialize(pos: Vec3.new, color: Color.new, strength: 1)
    @p = pos
    @color = color
    @strength = strength
  end

  def color(pos = nil)
    return pos ? @color * strength(pos) : @color
  end

  def strength(pos)
    dist = (@p - pos).length
    falloff = 5 ** -dist
    @strength * falloff    #TODO: Add different falloffs (f.e. spotlight)
  end
end
