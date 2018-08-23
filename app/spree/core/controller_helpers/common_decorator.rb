Spree::Core::ControllerHelpers::Common.module_eval do
  protected

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
