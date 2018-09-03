module SolidusSeo
  module Jsonld
    module TagHelper
      # @param item [Object] A jsonld hash or any object that implements `to_jsonld` method
      # @param opts[:exclude] [Array] Blacklist of attributes from jsonld
      # @param opts[:only] [Array] Whitelist of attributes from jsonld
      # @param opts[:force] [Boolean] Force cache miss
      #
      # @return [String] Retrieves jsonld tag markup.
      def jsonld(item, opts = {})
        jsonld_fetch(:base, item, opts.symbolize_keys)
      end

      def jsonld_list(collection)
        capture_jsonld(:list, jsonld_fetch(:list, collection))
      end

      def jsonld_breadcrumbs(breadcrumbs)
        jsonld_fetch(:breadcrumbs, breadcrumbs)
      end

      def captured_jsonld
        @captured_jsonld ||= {}
        @captured_jsonld.values.join("\n").html_safe
      end

      def dump_jsonld
        captured_jsonld + jsonld(current_store)
      end

      private

      def capture_jsonld(key, value)
        @captured_jsonld ||= {}

        return unless value
        @captured_jsonld[key.to_sym] = value
        nil # Ensure no output is returned
      end

      def jsonld_fetch(type = :base, items = nil, opts = {})
        force = opts.extract!(:force) || false

        jsonld_cache_key = [:jsonld, items, *opts.values].compact

        Rails.cache.fetch(jsonld_cache_key, force: force) do
          jsonld_builder_class = "SolidusSeo::Jsonld::#{type.to_s.titleize}".constantize
          jsonld_builder_class.new(items).print(opts)
        end
      end
    end
  end
end
