module SolidusSeo
  module Helpers
    module UrlHelper
      def default_url_options
        ActionController::Base.default_url_options
      end

      private

      def store_url
        @store_url ||= begin
          return self.url if self.respond_to? :url
          return self.store.url if self.respond_to? :store
          return self.stores.first.url if self.respond_to? :stores

          Spree::Store.default.url
        end
      end

      def image_url(url, host: nil)
        host ||= full_store_url
        ActionController::Base.helpers.image_url(url, host: host)
      end

      def route_helper
        Rails.application.routes.url_helpers
      end

      def spree_route_helper
        Spree::Core::Engine.routes.url_helpers
      end

      def full_store_url
        @full_store_url ||= begin
          url = store_url
          return "http#{'s' if Rails.application.config.force_ssl}://#{url}" unless url =~ /^https?/

          url
        end
      end
    end
  end
end
