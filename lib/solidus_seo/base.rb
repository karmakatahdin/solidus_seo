module SolidusSeo
  class Base
    include ActionView::Helpers::JavaScriptHelper
    include ActionView::Helpers::TagHelper

    def initialize(data)
      @data = data
      parse
    end

    def print(only: nil, exclude: nil)
      return if data.blank?

      output = filter(only: only, exclude: exclude)
      javascript_tag(output.to_json, type: 'application/ld+json').html_safe
    end

    private

    attr_accessor :data

    def parse
      data = @data.try(:to_jsonld) || @data
      raise('Unable to convert provided json-ld data to JSON') unless data.respond_to?(:to_json)
      @data = data.with_indifferent_access
    end

    def filter(only: nil, exclude: nil)
      if only.present?
        only |= %w[@context @type]
        return data.slice(*only)
      end

      return data.except(*exclude) if exclude.present?

      data
    end
  end
end
