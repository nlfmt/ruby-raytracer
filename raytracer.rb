require_relative "classes/engine"



WHITE = Color.new(255,255,255)
GREY = WHITE * 0.5
BLACK = Color.new(0,0,0)
RED = Color.new(255,0,0)
GREEN = Color.new(0,255,0)
BLUE = Color.new(0,0,255)


###############################
# Materials
###############################
red = Material.new(
  diffuse: RED,
  specular: WHITE.mult(0.4),
  roughness: 0.4,
  reflectivity: 0.5
)
blue = Material.new(
  diffuse: BLUE,
  specular: WHITE.mult(0.4),
  roughness: 0.4,
  reflectivity: 0.2,
)
purple = Material.new(
  diffuse: Color.new(190,0,255).mult(0.7),
  specular: WHITE,
  roughness: 0.8,
  reflectivity: 0.1,
)
metal = Material.new(
  diffuse: "tex/am_diffuse.png",
  specular: WHITE,
  roughness: 0.8,
  reflectivity: 1,
  normal: "tex/am_normal.png",
  normal_strength: 0.2
)
marble = Material.new(
  diffuse: "tex/mb_diffuse2.png",
  specular: WHITE,
  roughness: 0.8,
  reflectivity: 0,
  normal: "tex/mb_normal.png",
  normal_strength: 1
)
white = Material.new(
  diffuse: RED * 0.7,
  specular: WHITE * 0.5,
  roughness: 0.2,
  reflectivity: 0.05,
)
green = Material.new(
  diffuse: GREEN * 0.7,
  specular: WHITE,
  roughness: 0.2,
  reflectivity: 0.3,
)
gp = Material.new(
  diffuse: Color.new(50,50,50),
  specular: WHITE * 0.7,
  roughness: 0.7,
  reflectivity: 0.001,
)
cliffrock = Material.new(
  diffuse: "tex/rc_diffuse.tif",
  specular: WHITE * 0.3,
  roughness: 0.7,
  reflectivity: 0,
  normal: "tex/rc_normal.tif",
  normal_strength: 0.7
)
celticgold = Material.new(
  diffuse: "tex/cg_diffuse.png",
  specular: Color.new(255,200,0),
  roughness: 0.7,
  reflectivity: 0.3,
  normal: "tex/cg_normal.png"
)
debug = Material.new(
  diffuse: "tex/img.png",
  specular: Color.red
)
grass = Material.new(
  diffuse: "tex/sg_diffuse.png",
  specular: WHITE,
  roughness: 0.7,
  reflectivity: 0,
  normal: "tex/sg_normal.png"
)
redrock = Material.new(
  diffuse: "tex/ww_diffuse.png",
  specular: WHITE,
  roughness: 0.7,
  reflectivity: 0,
  normal: "tex/ww_normal.png"
)
stylizedcliff = Material.new(
  diffuse: "tex/sc_diffuse.png",
  specular: WHITE,
  roughness: 0.7,
  reflectivity: 0,
  normal: "tex/sc_normal.png"
)

###############################
# Lights
###############################
rimlight = Light.new(
  color: Color.new(110,110,255).mult(0.3),
  pos: Vec3.new(0, 0.5, 1.2),
  strength: 4
)
coldlight = Light.new(
  color: Color.new(255,255,255).mult(0.3),
  pos: Vec3.new(0.2, 1, 0.5),
  strength: 10
)
coldlight2 = Light.new(
  color: Color.new(255,255,255).mult(0.3),
  pos: Vec3.new(0, -0.5, 0.9),
  strength: 2
)
warmlight = Light.new(
  color: WHITE * 0.7,
  pos: Vec3.new(-0.2, 0.2, 0.9),
  strength: 2
)
warmlight2 = Light.new(
  color: WHITE * 0.7,
  pos: Vec3.new(0, 3, 1),
  strength: 6
)
###############################
# Objects
###############################
floor = Plane.new(
  pos: Vec3.new(0,-0.1,0),
  mat: gp
)
left = Plane.new(
  pos: Vec3.new(-0.5,0,0),
  mat: red,
  normal: Vec3.new(1,0,0)
)
right = Plane.new(
  pos: Vec3.new(0.5,0,0),
  mat: blue,
  normal: Vec3.new(-1,0,0)
)
top = Plane.new(
  pos: Vec3.new(0,0.6,0),
  mat: white,
  normal: Vec3.down
)
back = Plane.new(
  pos: Vec3.new(0,0,2),
  mat: purple,
  normal: Vec3.new(0,0,-1)
)
box = [floor,left,right,top,back]
s1 = Sphere.new(
  pos: Vec3.new(0, 0, 1.2),
  rad: 0.1,
  mat: celticgold

)
s2 = Sphere.new(
  pos: Vec3.new(-0.1, 0.13, 1.2),
  rad: 0.02,
  mat: blue

)
s3 = Sphere.new(
  pos: Vec3.new(0.23, 0, 1.13),
  rad: 0.09,
  mat: purple

)
s4 = Sphere.new(
  pos: Vec3.new(0, 0, 1.5),
  rad: 0.2,
  mat: white

)

###############################
# Cam & Scene
###############################
cam = Camera.new(
  width: 1280,
  height: 720,
  pos: Vec3.new(0,0.05,0.5)
)
dbgcam = Camera.new(
  width: 640,
  height: 360,
  pos: Vec3.new(0,0.05,0.5)
)
sc1 = Scene.new(
  objects: [s4, box].flatten, # , s2, s3, s4,
  lights: [coldlight2, warmlight, rimlight],
  filename: "scene1",
  cam: dbgcam, #cam,
  env: "tex/the_lost_city_4k.png"
)

engine = RenderEngine.new(feedback: nil)
puts "Loading finished"
sleep(1)
start = Time.now
engine.render(sc1)
puts "\nRendertime: #{(Time.now - start).round}s"
system("start scene1.ppm")
