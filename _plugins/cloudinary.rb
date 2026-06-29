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
    "hero"    => "f_auto,q_auto,c_limit,w_2800",
    "hero_md" => "f_auto,q_auto,c_limit,w_1920",
    "hero_sm" => "f_auto,q_auto,c_limit,w_1280",
    "hero_xs" => "f_auto,q_auto,c_limit,w_640",
    "blur"    => "f_auto,q_auto,c_limit,w_200,e_blur:1000",
    "thumb"   => "f_auto,q_auto,c_fill,g_auto,ar_1:1,w_800",
    "tile"    => "f_auto,q_auto,c_fill,g_auto,ar_1:1,w_1000",
    "full"    => "f_auto,q_auto,c_limit,w_1600",
    "content" => "f_auto,q_auto,c_limit,w_1800",
  }.freeze

  def self.transform(value, preset = "content")
    value = value.to_s.strip
    return value if value.empty?

    tx = PRESETS[preset.to_s] || PRESETS["content"]

    # Full Cloudinary URL for our account: apply our preset to the base image.
    if value.include?("res.cloudinary.com/#{CLOUD}#{MARKER}")
      return value if value.include?("f_auto") # idempotent
      prefix, rest = value.split(MARKER, 2) # rest = "[transforms/]v123/public_id"
      # Drop any existing transformation chain (e.g. a named t_Thumbnail or inline
      # crops) that precedes the version, so our preset is applied to the base image
      # consistently — no double-processing.
      rest = rest.sub(%r{\A.*?(?=v\d+/)}, '') if rest =~ %r{v\d+/}
      return "#{prefix}#{MARKER}#{tx}/#{rest}"
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
