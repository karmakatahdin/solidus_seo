Spree::Product.class_eval do
  include SolidusSeo::Model

  def seo_name
    name
  end

  def seo_url
    spree_route_helper.product_url(self, host: store_host)
  end

  def seo_images
    return [] unless display_image.attachment.file?

    [
      url_helper.image_url(display_image.attachment.url(:large), host: store_host),
    ].compact
  end

  def seo_description
    plain_text(try(:meta_description).presence || try(:description))
  end

  def seo_brand
    @brand ||= taxons.detect { |it| it.root.name.downcase == 'brands' }.try(:name)
  end

  def seo_currency
    master.default_price.currency
  end

  def seo_price
    master.default_price.amount
  end

  def any_in_stock?
    return variants_including_master.any? unless Spree::Config.track_inventory_levels
    arel_conditions = [
      variants_including_master.arel_table[:track_inventory].eq(false),
      Spree::StockItem.arel_table[:count_on_hand].gt(0)
    ]
    in_stock_variants = variants_including_master.joins(:stock_items).where(arel_conditions.inject(:or))
    in_stock_variants.any?
  end

  def seo_data
    {
      title: seo_name,
      description: seo_description,
      name: seo_name,
      image_src: seo_images.first,
      og: {
        type: 'product',
        url: seo_url,
        brand: seo_brand,
        image: {
          _: :image_src,
          alt: seo_name,
        }
      },
      product: {
        price: {
          amount: seo_price,
          currency: seo_currency,
        }
      },
      twitter: {
        card: 'summary_large_image',
      }
    }
  end

  def jsonld_data
    {
      "@context": "http://schema.org/",
      "@type": "Product",
      "name": name,
      "url": seo_url,
      "image": seo_images,
      "description": seo_name,
      "sku": sku,
      "brand": seo_brand,
      # TODO: ratings/reviews
      # "aggregateRating": {
      #   "@type": "AggregateRating",
      #   "ratingValue": "4.4",
      #   "reviewCount": "89"
      # },
      "offers": {
        "@type": "Offer",
        "priceCurrency": seo_currency,
        "price": seo_price,
        "itemCondition": "http://schema.org/NewCondition",
        "availability": "http://schema.org/#{ any_in_stock? ? 'InStock' : 'OutOfStock'}",
      }
    }
  end
end
