module Spree
  module Core
    module ControllerHelpers
      module CommonDecorator
        def self.prepended(base)
          base.module_eval do
            attr_reader :custom_title

            def title
              custom_title || current_store.seo_tagline
            end

            def custom_title
              @title.presence || accurate_title.presence
            end

            def accurate_title
              # No default accurate_title (controller-level SEO title)
              # so we can detect when there's no seo title defined,
              # make it fallback to Spree::Store#seo_tagline
              # field and then reverse the title output in
              # SolidusSeo::MetaDataBuilder#set_meta_data
            end
          end
        end

        ::Spree::Core::ControllerHelpers::Common.prepend(self)
      end
    end
  end
end
