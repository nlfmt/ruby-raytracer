class Ray

  attr_accessor :o, :d

  def initialize(o,d)
    @o = o
    @d = d.normalize
  end

  def getPos(dist)
    @o + @d * dist
  end

end
