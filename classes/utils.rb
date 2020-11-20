def clamp01(num)

  if(num < 0)
    num = 0
  elsif(num > 1)
    num = 1
  end
  return num
end

def mix(c1, c2, f)
  if c1.class == Integer || c1.class == Float
    return (c1 * f + c2 * (1 - f))
  end
  (c1.mult(f) + c2.mult(1 - f))
end

def uvs(pos)
  u = 0.5 + (Math.atan2(pos.x, -pos.z) / (2 * Math::PI))
  v = 0.5 - (Math.asin(pos.y) / Math::PI)
  return [u, v]
end
