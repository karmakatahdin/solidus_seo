require_dependency 'solidus_seo/meta_data_builder'

module Spree
  module StoreControllerDecorator
    def self.prepended(base)
      base.class_eval do
        include ::SolidusSeo::MetaDataBuilder
      end
    end

    ::Spree::StoreController.prepend(self)
  end
end
