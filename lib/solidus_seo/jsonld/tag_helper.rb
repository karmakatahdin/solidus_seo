module SolidusSeo
  module Jsonld
    module TagHelper
      def jsonld(item, exclude: nil, only: nil)
        SolidusSeo::Jsonld::Base.new(item).print(exclude: exclude, only: only)
      end

      def jsonld_list(collection)
        SolidusSeo::Jsonld::List.new(collection).print
      end

      def jsonld_breadcrumbs(breadcrumbs)
        SolidusSeo::Jsonld::Breadcrumbs.new(breadcrumbs).print
      end
    end
  end
end
