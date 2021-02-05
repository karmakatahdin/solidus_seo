require_dependency 'solidus_seo/model'

module Spree
  module ProductDecorator
    def self.prepended(base)
      base.class_eval do
        include SolidusSeo::Model
      end
    end

    def seo_name
      plain_text(try(:meta_title).presence) || name
    end

    def seo_url
      spree_route_helper.product_url(self, host: store_host)
    end

    def seo_images
      return [] unless gallery.images.any? && gallery.images.first.attachment.file?

      [
        url_helper.image_url(gallery.images.first.attachment.url(:large), host: store_host),
      ].compact
    end

    def seo_description
      plain_text(try(:meta_description).presence || try(:description))
    end

    def seo_brand
      @brand ||= taxons.detect { |it| it.root.name =~ /^brands?$/i }.try(:name)
    end

    def seo_currency
      master.default_price.currency
    end

    def seo_price
      master.default_price.amount
    end

    def in_stock?
      available? && variants_including_master.suppliable.any?
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
          "availability": "http://schema.org/#{ in_stock? ? 'InStock' : 'OutOfStock'}",
        }
      }
    end

    ::Spree::Product.prepend(self)
  end
end
