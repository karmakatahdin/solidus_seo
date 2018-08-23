module SolidusSeo
  module MetaDataBuilder
    include Spree::BaseHelper
    include SolidusSeo::Helpers::SanitizerHelper

    def render(*args)
      set_meta_data
      super
    end

    def set_meta_data
      # Default data
      meta_data = {
        reverse: custom_title.present?,
        title: title,
        og: {
          url: request.url,
          description: :description,
          title: :title,
        }
      }.deep_merge(current_store.to_seo.deep_symbolize_keys)
       .deep_merge(resource_meta_data)

      set_meta_tags meta_data
    end

    def resource_meta_data
      object = @product
      meta = {}

      if object.is_a? ActiveRecord::Base
        if object.respond_to? :to_seo
          meta = object.to_seo
        else
          meta_columns = object.class.column_names.keep_if { |col_name| col_name.starts_with? 'meta_' }
          meta_columns.each do |meta_column|
            base_column_name = meta_column.gsub 'meta_', ''
            # with fallback: meta_description or description
            meta[base_column_name] = object.try(meta_column).presence || object.try(base_column_name).presence
          end
        end
      end

      meta.deep_symbolize_keys
    end
  end
end
