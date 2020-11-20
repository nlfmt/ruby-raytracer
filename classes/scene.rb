class Scene

  attr_accessor :filename, :cam, :objects, :lights, :env

  def initialize(lights: [], objects: [], filename: "untitled", cam:,env: Color.new)
    @objects = objects
    @lights = lights
    @filename = filename
    @cam = cam
    @env = env.class != Color ? Texture.new(env) : env
  end

end
