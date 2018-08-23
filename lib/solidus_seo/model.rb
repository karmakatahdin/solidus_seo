module SolidusSeo
  module Model
    include SolidusSeo::Helpers::SanitizerHelper
    include SolidusSeo::Helpers::UrlHelper

    include SolidusSeo::Jsonld

    def to_seo
      @seo_data ||= seo_data.delete_if { |_, v| v.blank? }.with_indifferent_access
    end
  end
end
