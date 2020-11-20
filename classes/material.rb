class Material

attr_accessor :diffuse, :roughness, :specular, :reflectivity, :normal, :normal_strength

  def initialize(
    diffuse: Color.new(200,200,200),
    specular: Color.new(255,255,255),
    roughness: 0,
    reflectivity: 0,
    normal: nil,
    normal_strength: 1)


    @diffuse = diffuse
    @specular = specular
    @roughness = roughness
    @reflectivity = reflectivity

    if diffuse.class != Color then @diffuse = Texture.new(diffuse) end
    if specular.class != Color then @specular = Texture.new(specular) end

    if normal != nil
      @normal = Texture.new(normal)
      @normal_strength = normal_strength
    end

  end

  def diffuse(uvs = [0,0])
    if @diffuse.class != Color
      return @diffuse.color_at(uvs)
    else
      return @diffuse
    end
  end

  def specular(uvs = [0,0])
    if @specular.class != Color
      return @specular.color_at(uvs)
    else
      return @specular
    end
  end

  def normal(uvs = [0,0], n)
    tn = ((@normal.color_at(uvs).to_v + Vec3.new(1,1,1)) / Vec3.new(256, 256, 256)).mult(2.0) - Vec3.new(1,1,1)

    u = uvs[0]

    t = Vec3.new(-Math.cos(u * 2 * Math::PI), 0, -Math.sin(u * 2 * Math::PI)).normalize # Tangent
    b = cross(t, n).normalize # Bitangent

    # Rotate Vector with TBN Matrix
    ws_normal = Vec3.new(
      tn.x * t.x + tn.y * t.y + tn.z * t.z,
      tn.x * b.x + tn.y * b.y + tn.z * b.z,
      tn.x * n.x + tn.y * n.y + tn.z * n.z
    )
    ws_normal = mix(ws_normal, n, @normal_strength)
    return ws_normal.normalize

  end

end
