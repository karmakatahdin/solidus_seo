module SolidusSeo
  module Model
    include SolidusSeo::Helpers::SanitizerHelper
    include SolidusSeo::Helpers::UrlHelper

    def to_jsonld
      raise "This method needs to be implemented!"
    end
  end
end
