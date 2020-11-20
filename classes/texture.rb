require "rmagick"

class Texture

  attr_accessor :width, :height, :texture

  def initialize(path)
    #t = Time.now
    @texture = Magick::ImageList.new(path)
    @width, @height = @texture.columns, @texture.rows

    #puts "Loaded #{path} (#{((Time.now - t) * 1000).round()}ms)"
  end

  def color_at(uvs)
    tx = (uvs[0] * (@width - 1)).floor
    ty = (uvs[1] * (@height - 1)).floor
    pixel = @texture.get_pixels(tx, ty, 1, 1)[0]

    return Color.new(
      ((pixel.red + 1) / 256 - 1).floor,
      ((pixel.green + 1) / 256 - 1).floor,
      ((pixel.blue + 1) / 256 - 1).floor
    ).clamp
  end
end
