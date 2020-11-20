require_relative "classes/vec3"
require_relative "classes/ray"
require_relative "classes/sphere"
require_relative "classes/utils"
require_relative "classes/scene"
require_relative "classes/material"
require_relative "classes/camera"
require_relative "classes/texture"



tn = Vec3.new(1,1,0)

t = Vec3.new(0,0,1)
b = Vec3.new(0,1,0)
n = Vec3.new(1,0,0)

#puts cross(t, n)

ws_normal = Vec3.new(
  tn.x * t.x + tn.y * t.y + tn.z * t.z,
  tn.x * b.x + tn.y * b.y + tn.z * b.z,
  tn.x * n.x + tn.y * n.y + tn.z * n.z
)
#puts ws_normal
