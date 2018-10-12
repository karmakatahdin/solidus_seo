Spree::Store.class_eval do
  include SolidusSeo::Model

  # following conventions of other models
  def seo_name
    seo_title.presence || name
  end

  def seo_image
    url_helper.image_url(Spree::Config.logo, host: store_host)
  end

  def seo_description
    plain_text(meta_description)
  end

  def seo_tagline
    # TODO: Retrieve from DB
    'This is the default store tagline'
  end

  def seo_data
    {
      site: seo_name,
      description: seo_description,
      image_src: seo_image,
      og: {
        site_name: :site,
        type: 'website',
        image: {
          '_': :image_src,
          alt: :site
        }
      },
      twitter: {
        card: 'summary',
        # site: '@yourcompany'
      }
    }
  end

  def jsonld_data
    base = {
      "@context": "http://schema.org",
      "@type": "Store",
      "name": name,
      "logo": seo_image,
      "image": seo_image,
      "url": store_host,
      "@id": store_host
    }

    build_jsonld_with base, :contact_points,
                            :address,
                            :geo,
                            :same_as,
                            :opening_hours_specification
  end
end
