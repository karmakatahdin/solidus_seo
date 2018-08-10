module SolidusSeo
  module Model
    include SolidusSeo::Helpers::SanitizerHelper
    include SolidusSeo::Helpers::UrlHelper

    include SolidusSeo::Jsonld
  end
end
