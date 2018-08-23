module SolidusSeo
  module Helpers
    module UrlHelper
      def url_helper
        ActionController::Base.helpers
      end

      def route_helper
        Rails.application.routes.url_helpers
      end

      def spree_route_helper
        Spree::Core::Engine.routes.url_helpers
      end

      def default_url_options
        ActionController::Base.default_url_options
      end

      def store_host
        @store_host ||=  begin
          store_url = Spree::Store.default.url
          store_url = "http#{'s' if ssl?}://#{store_url}" unless store_url =~ /^https?/
          store_url
        end
      end

      private

      def ssl?
        Rails.application.config.force_ssl
      end
    end
  end
end
