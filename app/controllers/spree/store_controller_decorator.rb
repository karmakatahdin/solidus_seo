Spree::StoreController.class_eval do
  include SolidusSeo::MetaDataBuilder
  helper SolidusSeo::Jsonld::TagHelper
end
