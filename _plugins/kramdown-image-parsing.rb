require 'kramdown/converter/html'

module StandaloneImages
  def convert_p(el, indent)
    return super unless el.children.size == 1 && (el.children.first.type == :img || (el.children.first.type == :html_element && el.children.first.value == "img"))
    convert(el.children.first, indent)
  end

  # Optimise every inline image: route Cloudinary URLs through the transform,
  # lazy-load + async-decode, and fall back to the markdown title for alt text.
  def convert_img(el, indent)
    if defined?(Cloudinary) && el.attr["src"]
      el.attr["src"] = Cloudinary.transform(el.attr["src"], "content")
    end
    el.attr["loading"]  ||= "lazy"
    el.attr["decoding"] ||= "async"
    if el.attr["alt"].to_s.strip.empty? && !el.attr["title"].to_s.strip.empty?
      el.attr["alt"] = el.attr["title"]
    end
    super
  end
end

Kramdown::Converter::Html.prepend StandaloneImages