Spree::Product.class_eval do
  include SolidusSeo::Model

  def brand
    @brand ||= taxons.detect { |it| it.root.name.downcase == 'brands' }
  end

  def can_supply_any?
    variants_including_master.any?(&:can_supply?)
  end

  def to_seo
    image_url = url_helper.image_url(display_image.attachment.url, host: store_host)

    {
      keywords: meta_keywords,
      description: meta_description.presence || description,
      image_src: image_url,
      og: {
        type: 'product',
        image: {
          _: :image_src,
          # width: 200,
          # height: 200,
        }
      }
    }
  end

  def to_jsonld
    @jsonld ||= begin
      store = Spree::Store.default

      {
        "@context": "http://schema.org/",
        "@type": "Product",
        "name": name,
        "url": spree_route_helper.product_url(self, host: store.url),
        "image": [
          url_helper.image_url(display_image.attachment.url(:large), host: store_host),
          url_helper.image_url(display_image.attachment.url(:xl), host: store_host),
          url_helper.image_url(display_image.attachment.url(:wide), host: store_host),
        ],
        "description": plain_text(description),
        "sku": sku,
        "brand": brand.try(:name),
        # "aggregateRating": {
        #   "@type": "AggregateRating",
        #   "ratingValue": "4.4",
        #   "reviewCount": "89"
        # },
        "offers": {
          "@type": "Offer",
          "priceCurrency": master.default_price.currency,
          "price": master.default_price.amount,
          "itemCondition": "http://schema.org/NewCondition",
          "availability": "http://schema.org/#{ can_supply_any? ? 'InStock' : 'OutOfStock'}",
        }
      }.compact.with_indifferent_access
    end
  end
end
