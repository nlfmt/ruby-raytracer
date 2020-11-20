class Vec3

  attr_accessor :x, :y, :z

  def initialize(x = 0, y = 0, z = 0)
    @x = x
    @y = y
    @z = z
  end

  def length
    Math.sqrt(@x*@x + @y*@y + @z*@z)
  end

  def to_s
    "#{@x},#{@y},#{@z}"
  end

  def normalize
    x = @x * (1.0 / self.length)
    y = @y * (1.0 / self.length)
    z = @z * (1.0 / self.length)
    Vec3.new(x,y,z)
  end

  def mult(fac)
    x = @x * fac
    y = @y * fac
    z = @z * fac
    Vec3.new(x,y,z)
  end
  def *(other)
    return self.mult(other) if other.class != Vec3
    x = @x * other.x
    y = @y * other.y
    z = @z * other.z
    Vec3.new(x,y,z)
  end
  def /(other)
    x = @x / other.x.to_f
    y = @y / other.y.to_f
    z = @z / other.z.to_f
    Vec3.new(x,y,z)
  end
  def +(other)
    x = @x + other.x
    y = @y + other.y
    z = @z + other.z
    Vec3.new(x,y,z)
  end
  def -(other)
    x = @x - other.x
    y = @y - other.y
    z = @z - other.z
    Vec3.new(x,y,z)
  end

  def self.up
    Vec3.new(0,1,0)
  end
  def self.down
    Vec3.new(0,-1,0)
  end
end

#Cross Product
def cross(a,b)
  x = a.y * b.z - a.z * b.y
  y = a.z * b.x - a.x * b.z
  z = a.x * b.y - a.y * b.x
  Vec3.new(x,y,z)
end

#Dot Product
def dot(a,b)
   return (a.x * b.x + a.y * b.y + a.z * b.z)
end

def sqr(num)
 num * num
end

def reflect(normal, dir)
  dir - normal.mult(2 * (dot(normal, dir)))
end

def max(c1, c2)
  return [c1,c2].max
end
