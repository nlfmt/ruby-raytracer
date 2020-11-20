class Plane

  attr_accessor :p, :n, :mat

  def initialize(pos: Vec3.new(0,0,0), normal: Vec3.up, mat: Material.new)
    @p = pos
    @n = normal.normalize
    @mat = mat
  end

  def normal(pos)
    @n
  end

  def intersect(ray)

    return nil if(dot(ray.d,@n) == 0)

    dist = (1/dot(ray.d,@n) * (dot(@p,@n) - dot(ray.o,@n)))

    return dist > 0 ? dist : nil
  end
end
