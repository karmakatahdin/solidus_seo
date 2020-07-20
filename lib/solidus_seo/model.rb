require_dependency 'solidus_seo/helpers/base_helper'
require_dependency 'solidus_seo/helpers/url_helper'
require_dependency 'solidus_seo/jsonld'

module SolidusSeo
  module Model
    include SolidusSeo::Helpers::BaseHelper
    include SolidusSeo::Helpers::UrlHelper
    include SolidusSeo::Jsonld

    def to_seo
      @seo_data ||= seo_data.delete_if { |_, v| v.blank? }.with_indifferent_access
    end
  end
end
