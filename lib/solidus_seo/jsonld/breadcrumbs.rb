require_dependency 'solidus_seo/jsonld/list'

module SolidusSeo
  module Jsonld
    class Breadcrumbs < SolidusSeo::Jsonld::List
      private

      def list_type
        'BreadcrumbList'
      end

      def already_a_list?
        data.is_a?(Hash) && data["@type"] == list_type
      end

      def as_list_item(item)
        # `item` in the form of [text, url]
        breadcrumb_text, breadcrumb_url = item

        {
          '@type': 'ListItem',
          position: list_items.size + 1,
          item: {
            '@id': breadcrumb_url,
            name: breadcrumb_text
          }
        }
      end
    end
  end
end
