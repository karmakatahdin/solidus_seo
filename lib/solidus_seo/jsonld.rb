require_dependency 'solidus_seo/jsonld/core'
require_dependency 'solidus_seo/jsonld/builder'

module SolidusSeo
  module Jsonld
    include SolidusSeo::Jsonld::Core
    include SolidusSeo::Jsonld::Builder
  end
end
