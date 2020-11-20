class Sphere

  attr_accessor :p, :r, :mat

  def initialize(pos: Vec3.new, rad: 1, mat: Material.new)
    @p = pos
    @r = rad
    @mat = mat
  end

  def normal(pos)

    n = (pos - @p).normalize

    return @mat.normal_strength != nil ? @mat.normal(uvs(n), n) : n
  end

  def intersect(ray)
    o = ray.o - @p

    b = 2 * dot(o, ray.d)
    c = dot(o,o) - (@r * @r)
    discr = b * b - 4 * c

    if discr >= 0
      dist = (-b - Math.sqrt(discr)) / 2
      return dist if dist > 0
    end
    return nil
  end

end
