module SolidusSeo
  module MetaDataBuilder
    include Spree::BaseHelper
    include SolidusSeo::Helpers::SanitizerHelper

    def render(*args)
      set_meta_data
      super
    end

    def set_meta_data
      # Defaults
      meta = {
        title: title,
        keywords: current_store.meta_keywords,
        description: current_store.meta_description,
        og: {
          type: 'website',
          title: :title,
          keywords: :keywords,
          description: :description,
          url: request.url,
        }
      }

      meta = format_meta_data(meta.deep_merge(resource_meta_data))

      set_meta_tags meta
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

      meta
    end

    def format_meta_data(meta_data, tags = %i(description))
      tags.each do |meta_tag|
        meta_data[meta_tag] = plain_text(meta_data[meta_tag]) if meta_data[meta_tag].present?
      end

      meta_data
    end
  end
end
