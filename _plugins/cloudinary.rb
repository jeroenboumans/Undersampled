# Cloudinary URL transform helper + Liquid filter.
#
# Usage in templates:
#   {{ page.heroImage | default: page.image | cloudinary: 'hero' }}
#
# Accepts three kinds of input:
#   * a full Cloudinary URL for our account  -> injects the preset transform
#   * a bare public id / path (e.g. "M101/M101_LHaRGB_lp9ekd") -> builds the URL
#   * an external URL or local "/assets/..." path -> left untouched
module Cloudinary
  CLOUD = "undersampled".freeze
  BASE  = "https://res.cloudinary.com/#{CLOUD}/image/upload/".freeze
  MARKER = "/image/upload/".freeze

  PRESETS = {
    "hero"    => "f_auto,q_auto,c_limit,w_3200",
    "blur"    => "f_auto,q_auto,c_limit,w_200,e_blur:1000",
    "thumb"   => "f_auto,q_auto,c_fill,g_auto,ar_1:1,w_800",
    "tile"    => "f_auto,q_auto,c_fill,g_auto,ar_1:1,w_1000",
    "full"    => "f_auto,q_auto,c_limit,w_1600",
    "content" => "f_auto,q_auto,c_limit,w_3200",
  }.freeze

  def self.transform(value, preset = "content")
    value = value.to_s.strip
    return value if value.empty?

    tx = PRESETS[preset.to_s] || PRESETS["content"]

    # Full Cloudinary URL for our account: inject the transform after /image/upload/
    if value.include?("res.cloudinary.com/#{CLOUD}#{MARKER}")
      return value if value.include?("f_auto") # idempotent
      return value.sub(MARKER, "#{MARKER}#{tx}/")
    end

    # External URL or local asset path: leave untouched
    return value if value.start_with?("http://", "https://", "/")

    # Bare public id / path: build the full URL
    "#{BASE}#{tx}/#{value.sub(%r{\A/+}, '')}"
  end
end

module Jekyll
  module CloudinaryFilter
    def cloudinary(input, preset = "content")
      Cloudinary.transform(input, preset)
    end
    alias_method :cl, :cloudinary
  end
end

Liquid::Template.register_filter(Jekyll::CloudinaryFilter)
