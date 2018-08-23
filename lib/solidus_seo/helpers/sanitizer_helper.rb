module SolidusSeo
  module Helpers
    module SanitizerHelper
      def plain_text(text)
        ActionController::Base.helpers.strip_tags(text.to_s).gsub(/\s+/, ' ')
      end
    end
  end
end
