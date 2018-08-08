module SolidusSeo
  module Helpers
    module TagHelper
      def jsonld(item, exclude: nil, only: nil)
        SolidusSeo::Base.new(item).print(exclude: exclude, only: only)
      end

      def jsonld_list(collection)
        SolidusSeo::List.new(collection).print
      end

      def jsonld_breadcrumbs(breadcrumbs)
        SolidusSeo::Breadcrumbs.new(breadcrumbs).print
      end
    end
  end
end
