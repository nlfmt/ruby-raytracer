# Base classes
require_relative "color"
require_relative "vec3"
# Objects
require_relative "light"
require_relative "plane"
require_relative "sphere"
require_relative "ray"
# Data Classes
require_relative "camera"
require_relative "texture"
require_relative "material"
require_relative "scene"
# Utility
require_relative "utils"


class RenderEngine

  attr_accessor :MAX_DEPTH, :MIN_DISPLACE

  def initialize(reflection_depth: 3, min_displace: 0.0001, shadow_samples: 60, feedback: nil)
    @MAX_DEPTH = reflection_depth
    @MIN_DISPLACE = min_displace
    @SHADOW_SAMPLES = shadow_samples
    @feedback = feedback
    @lastprogress = "000" if feedback == "simple"
  end


  def render(scene)
    cam = scene.cam
    width, height = cam.width, cam.height
    aspect_ratio = width / height.to_f
    x0 = -1.0
    x1 = 1.0
    y0 = -1.0 / aspect_ratio
    y1 = 1.0 / aspect_ratio
    xstep = (x1 - x0) / (width - 1)
    ystep = (y1 - y0) / (height - 1)

    img = File.open("#{scene.filename}.ppm", "w")
    img.write("P3\n" + "#{width} #{height} 255\n")

    # Info to print in full feedback mode before progress
    info = "Rendering: #{scene.filename}\nObjects: #{scene.objects.length}\nLights: #{scene.lights.length}\n"


    for j in 1..height do
      y = y0 + j * ystep


      # Feedback: Simple for Python script, full for single run
      if @feedback == "simple"
        progress = "#{(j / height.to_f * 100.0).round(0)}".strip
        progress = "0" * (3-progress.size)

        if @lastprogress != progress
          system("echo #{progress}")
        end
        @lastprogress = progress

      elsif @feedback == "full"
        system("clear")
        puts info + "#{(j / height.to_f * 100.0).round(0)}"
      end


      width.times do |i|
        x = x0 + i * xstep

        # Camera ray
        ray = Ray.new(cam.pos, Vec3.new(x, -y, 2) - cam.pos)

        # Calculate color
        clr = self.raytrace(ray, scene).to_i

        # Write to file
        img.write("#{clr.r} #{clr.g} #{clr.b}\n")
      end
    end
    img.close

  end

  def raytrace(ray, scene, depth = 0)

    color = Color.new

    # Find nearest object
    info = self.find_nearest(ray, scene)
    dist_hit, obj_hit = info[0], info[1]

    # Sample Environment Map Color if no object was hit
    if obj_hit == nil
      return self.sample_env(scene, ray)
    end

    hit_pos = ray.getPos(dist_hit)
    hit_normal = obj_hit.normal(hit_pos)

    color = self.color_at(obj_hit, hit_pos, hit_normal, scene)


    if depth < @MAX_DEPTH

      to_orig = ray.o - hit_pos

      new_rpos = hit_pos + hit_normal.mult(@MIN_DISPLACE)
      new_rdir = reflect(hit_normal, ray.d)
      new_ray = Ray.new(new_rpos, new_rdir)

      # Fresnel Effect (Reflection strength increases with decreasing hit angle)
      fresnel = mix(1, (1 - dot(to_orig.normalize, hit_normal.normalize).clamp(0,1)) ** 4, obj_hit.mat.reflectivity)

      specular = obj_hit.mat.specular(uvs((hit_pos - obj_hit.p).normalize))

      # Reflection color through recursion
      reflection_color = self.raytrace(new_ray, scene, depth + 1) * specular * fresnel

      color = color + reflection_color
    end


    return color
  end

  def find_nearest(ray, scene)
    dist_min = nil
    obj_hit = nil

    scene.objects.each do |obj|
      dist = obj.intersect(ray)
      if dist != nil && (obj_hit == nil || dist < dist_min)
        dist_min = dist
        obj_hit = obj
      end
    end
    return [dist_min, obj_hit]
  end

  def color_at(obj_hit, hit_pos, normal, scene)
    mat = obj_hit.mat
    uvs = uvs((hit_pos - obj_hit.p).normalize)

    to_cam = scene.cam.pos - hit_pos
    specular_k = 250

    specular = Color.new
    emission = Color.new

    scene.lights.each do |light|
      to_light = light.p - hit_pos

      # shadowray = Ray.new(hit_pos, to_light)
      # shadow = false
      # scene.objects.each do |obj|
      #   dist = obj.intersect(shadowray)
      #   if obj != obj_hit && dist != nil && dist < (light.p - hit_pos).length
      #     shadow = true
      #     break
      #   end
      # end
      shadow = 1
      @SHADOW_SAMPLES.times do
        deviation = Vec3.new(rand(),rand(),rand()).normalize * 0.6
        shadowray = Ray.new(hit_pos, to_light + deviation)
        scene.objects.each do |obj|
          dist = obj.intersect(shadowray)
          if obj != obj_hit && dist != nil && dist < (light.p - hit_pos).length
            shadow -= 1/@SHADOW_SAMPLES.to_f
            break
          end
        end
      end

      if shadow != 0
        # Sum of all light reaching this point
        emission = (emission + (light.color(hit_pos) * dot(normal, to_light.normalize).clamp(0,1))) * shadow

        # Specular (Light Glow Effect)
        half_vector = (to_light + to_cam).normalize
        falloff = dot(normal, half_vector).clamp(0,1) ** specular_k
        specular = (specular + (light.color(hit_pos) * mat.specular(uvs) * falloff)) * shadow
      end
    end

    #return Color.new(dbgn.x,dbgn.y,dbgn.z).mult(127)
    #return Color.new(uvs[0] * 255, uvs[1] * 255)
    return (emission * mat.diffuse(uvs) + specular)

  end

  def sample_env(scene, ray)
    if scene.env.class == Texture
      return scene.env.color_at(uvs(ray.d * Vec3.new(1,1,-1))) # Reverse Environment Map
    else
      return scene.env
    end
  end

end
=begin

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
  reflectivity: 0.5,
)
metal = Material.new(
  diffuse: "../tex/am_diffuse.png",
  specular: WHITE,
  roughness: 0.8,
  reflectivity: 1,
  normal: "../tex/am_normal.png",
  normal_strength: 0.3
)
marble = Material.new(
  diffuse: "../tex/mb_diffuse2.png",
  specular: WHITE,
  roughness: 0.8,
  reflectivity: 0,
  normal: "../tex/mb_normal.png",
  normal_strength: 1
)
white = Material.new(
  diffuse: GREY,
  specular: WHITE,
  roughness: 0.2,
  reflectivity: 1,
)
green = Material.new(
  diffuse: GREEN * 0.7,
  specular: WHITE,
  roughness: 0.2,
  reflectivity: 0.3,
)
gp = Material.new(
  diffuse: Color.new(100,100,100),
  specular: WHITE,
  roughness: 0.7,
  reflectivity: 0.8,
)
cliffrock = Material.new(
  diffuse: "../tex/rc_diffuse.tif",
  specular: WHITE * 0.3,
  roughness: 0.7,
  reflectivity: 0,
  normal: "../tex/rc_normal.tif",
  normal_strength: 0.7
)
celticgold = Material.new(
  diffuse: "../tex/cg_diffuse.png",
  specular: Color.new(255,200,0),
  roughness: 0.7,
  reflectivity: 0.3,
  normal: "../tex/cg_normal.png"
)
grass = Material.new(
  diffuse: "../tex/sg_diffuse.png",
  specular: WHITE,
  roughness: 0.7,
  reflectivity: 0,
  normal: "../tex/sg_normal.png"
)
redrock = Material.new(
  diffuse: "../tex/ww_diffuse.png",
  specular: WHITE,
  roughness: 0.7,
  reflectivity: 0,
  normal: "../tex/ww_normal.png"
)
stylizedcliff = Material.new(
  diffuse: "../tex/sc_diffuse.png",
  specular: WHITE,
  roughness: 0.7,
  reflectivity: 0,
  normal: "../tex/sc_normal.png"
)

###############################
# Lights
###############################
rimlight = Light.new(
  color: Color.new(110,110,255).mult(0.3),
  pos: Vec3.new(0, 1, 1.2)
)
coldlight = Light.new(
  color: Color.new(255,255,255).mult(0.3),
  pos: Vec3.new(0.2, 1, 0.5)
)
coldlight2 = Light.new(
  color: Color.new(255,255,255).mult(0.3),
  pos: Vec3.new(0, -0.5, 0.9)
)
warmlight = Light.new(
  color: WHITE * 0.7,
  pos: Vec3.new(-1, 1, 0.5)
)
warmlight = Light.new(
  color: WHITE * 0.7,
  pos: Vec3.new(0, 3, 1)
)
###############################
# Objects
###############################
gp = Plane.new(
  pos: Vec3.new(0,-0.1,0),
  mat: gp
)
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
  rad: 0.07,
  mat: grass

)
s4 = Sphere.new(
  pos: Vec3.new(-0.25, 0.07, 1.5),
  rad: 0.1,
  mat: redrock

)

###############################
# Cam & Scene
###############################
cam = Camera.new(
  width: 1280,
  height: 720,
  pos: Vec3.new(0,0.05,0.5)
)
sc1 = Scene.new(
  objects: [s1, s2, s3, s4, gp],
  lights: [coldlight, coldlight2, warmlight],
  filename: "scene1",
  cam: cam
)

engine = RenderEngine.new(env: "../tex/kloppenheim_06_2k.png")
puts "Loading finished"
sleep(1)
start = Time.now
engine.render(sc1)
puts "\nRendertime: #{(Time.now - start).round}s"
system("start scene1.ppm")

=end
