class Color

  attr_accessor :r, :g, :b, :range

  def self.red
    Color.new(255,0,0)
  end
  def self.green
    Color.new(0,255,0)
  end
  def self.blue
    Color.new(0,0,255)
  end
  def self.black
    Color.new(0,0,0)
  end
  def self.white
    Color.new(255,255,255)
  end
  def self.grey
    Color.new(127,127,127)
  end


  def initialize(r = 0, g = 0, b = 0, range: 255)
    @r,@g,@b = r,g,b
    @range = range
  end

  # Color Addition
  def +(other)
    r = @r + other.r
    g = @g + other.g
    b = @b + other.b
    Color.new(r,g,b).clamp
  end

  # Color Multiplication
  def *(other)
    return self.mult(other) if other.class != Color
    other_range = other.range.to_f
    r = (@r / @range.to_f) * (other.r / other_range) * @range
    g = (@g / @range.to_f) * (other.g / other_range) * @range
    b = (@b / @range.to_f) * (other.b / other_range) * @range
    Color.new(r,g,b)
  end

  def mult(fac)
    r = @r * fac
    g = @g * fac
    b = @b * fac
    Color.new(r,g,b)
  end

  def clamp(min = 0, max = @range)
    Color.new(
      @r.clamp(min,max),
      @g.clamp(min,max),
      @b.clamp(min,max)
    )
  end

# Conversion
  def to_s
    "#{@r}, #{@g}, #{@b}"
  end
  def to_a
    [@r,@g,@b]
  end
  def to_i
    r = @r.round
    g = @g.round
    b = @b.round
    Color.new(r,g,b)
  end
  def to_f
    r = @r.to_f
    g = @g.to_f
    b = @b.to_f
    Color.new(r,g,b)
  end
  def to_v
    Vec3.new(@r,@g,@b)
  end
end
