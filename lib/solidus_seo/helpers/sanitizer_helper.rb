module SolidusSeo
  module Helpers
    module SanitizerHelper
      def plain_text(text)
        ActionController::Base.helpers.strip_tags(text).gsub(/\s+/, ' ')
      end
    end
  end
end
