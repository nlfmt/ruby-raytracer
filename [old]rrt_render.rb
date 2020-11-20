require "json"
require_relative "classes/engine.rb"

scenepath = ARGV[0]
file = File.open(scenepath)
f = JSON.parse(file.read)

o = f["objects"]
m = f["materials"]

objects = []
materials = {}

# Create Material Hash
m.each_entry do |e|
  #puts e["diftex"]
  if e["diftex"] != nil then diffuse = e["diftex"] else diffuse = Vec3.new(e["difx"].to_f, e["dify"].to_f, e["difz"].to_f) end
  #if e["diftex"] != nil then print(e["diftex"], " not nil ") else print(e["diftex"], " nil ") end
  if e["spectex"] != nil then specular = e["spectex"] else specular = Vec3.new(e["specx"].to_f, e["specy"].to_f, e["specz"].to_f) end
  mat = Material.new(
    diffuse: diffuse,
    specular: specular,
    reflectivity: e["reflectivity"].to_f,
    emission: Vec3.new(e["emisx"].to_f, e["emisy"].to_f, e["emisz"].to_f),
    normal: e["normaltex"],
    normal_strength: e["normalstrength"].to_f
  )
  materials[e["name"]] = mat
end

# Create Object array with corresponding materials
o.each_entry do |e|
  matname = e["material"]
  mat = nil
  materials.each_key do |name|
    if matname == name
      mat = materials[name]
    end
  end
  obj = Sphere.new(
    pos: Vec3.new(e["posx"].to_f, e["posy"].to_f, e["posz"].to_f),
    rad: e["radius"].to_f,
    mat: mat
  )
  objects.push(obj)
end



#exit
#sleep(30)


settings = f["settings"]

cam = Camera.new(
  width: settings["width"],
  height: settings["height"],
  pos: Vec3.new(0,0.05,0.5)
)

scene = Scene.new(
  objects: objects,
  filename: scenepath[0..-4],
  cam: cam
)

engine = RenderEngine.new(env: "D:/Files/Code/Ruby Raytracer/tex/studio_small_01_4k.png")
#puts "Loading finished"
#sleep(1)
start = Time.now
engine.render(scene)
system("start #{scenepath[0..-4]}.ppm")
#puts "\nRendertime: #{(Time.now - start).round}s"
