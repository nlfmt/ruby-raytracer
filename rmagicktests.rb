require "rmagick"
require_relative "classes/vec3.rb"
require_relative "classes/colors.rb"

img = Magick::ImageList.new("tex/am_diffuse.png")
img.display
puts img.columns
p img.get_pixels(6, 6, 1, 1)[0].red, img.get_pixels(6, 6, 1, 1)[0].green, img.get_pixels(6, 6, 1, 1)[0].blue

puts Math::PI
p Vec3.new.class

=begin
array = []

img.each_pixel do |pixel, c, r|
  array.push(clamp255(Vec3.new(((pixel.red + 1) / 256 - 1).floor, ((pixel.green + 1) / 256 - 1).floor, ((pixel.blue + 1) / 256 - 1).floor)))
end

p array[0..5]
=end

puts (Math.atan2(1, 0) / (2 * Math::PI))

color = Vec3.new(127,127,255)

tangent_normal = ((color + Vec3.new(1,1,1)) / Vec3.new(256, 256, 256)).mult(2.0) - Vec3.new(1,1,1)

puts tangent_normal
