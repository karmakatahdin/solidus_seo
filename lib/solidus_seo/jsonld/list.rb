require_dependency 'solidus_seo/jsonld/base'

module SolidusSeo
  module Jsonld
    class List < Base
      attr_accessor :data, :list_items

      def initialize(data)
        @list_items = []
        @data = data.to_a

        parse
      end

      private

      def list_type
        'ItemList'
      end

      def parse
        return {} if @data.blank?
        return @data if already_a_list?

        @data.each do |it|
          list_items << as_list_item(it)
        end

        build_list
      end

      def build_list
        @data = {
          "@context": "http://schema.org",
          "@type": list_type,
          "itemListElement": list_items
        }.with_indifferent_access
      end

      def already_a_list?
        data.is_a?(Hash) && data["@type"] == list_type
      end

      def as_list_item(item)
        {
          '@type': 'ListItem',
          position: list_items.size + 1,
          url: get_list_item_url(item)
        }
      end

      def get_list_item_url(item)
        item = item.try(:to_jsonld) || item
        item.try(:url) || item.try('[]', :url) || raise("ListItem must define an URL")
      end
    end
  end
end
