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

  def to_jsonld
    @jsonld ||= begin
      {
        "@context": "http://schema.org",
        "@type": "FurnitureStore",
        "name": name,
        "logo": url_helper.image_url(Spree::Config.logo, host: url),
        "url": url,
        "@id": url,
        "address": {
          "@type": "PostalAddress",
          "streetAddress": "148 W 51st St",
          "addressLocality": "New York",
          "addressRegion": "NY",
          "postalCode": "10019",
          "addressCountry": "US"
        },
        "geo": {
          "@type": "GeoCoordinates",
          "latitude": 40.761293,
          "longitude": -73.982294
        },
        "telephone": "+12122459600",
        "openingHoursSpecification": [
          {
            "@type": "OpeningHoursSpecification",
            "dayOfWeek": [
              "Monday",
              "Tuesday"
            ],
            "opens": "11:30",
            "closes": "22:00"
          },
          {
            "@type": "OpeningHoursSpecification",
            "dayOfWeek": [
              "Wednesday",
              "Thursday",
              "Friday"
            ],
            "opens": "11:30",
            "closes": "23:00"
          },
          {
            "@type": "OpeningHoursSpecification",
            "dayOfWeek": "Saturday",
            "opens": "16:00",
            "closes": "23:00"
          },
          {
            "@type": "OpeningHoursSpecification",
            "dayOfWeek": "Sunday",
            "opens": "16:00",
            "closes": "22:00"
          }
        ]
      }.compact.with_indifferent_access
    end
  end
end
