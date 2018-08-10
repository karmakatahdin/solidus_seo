Spree::Store.class_eval do
  include SolidusSeo::Model

  def to_seo
    # image_url = display_image.attachment.url

    # {
    #   keywords: meta_keywords,
    #   description: meta_description.presence || description,
    #   image_src: image_url,
    #   og: {
    #     type: 'product',
    #     image: {
    #       _: :image_src,
    #       # width: 200,
    #       # height: 200,
    #     }
    #   }
    # }
  end

  def jsonld
    base = {
      "@context": "http://schema.org",
      "@type": "FurnitureStore",
      "name": name,
      "logo": url_helper.image_url(Spree::Config.logo, host: url),
      "url": url,
      "@id": url
    }

    build_jsonld_with base, :contact_points,
                            :address,
                            :geo,
                            :same_as,
                            :opening_hours_specification
  end
end
