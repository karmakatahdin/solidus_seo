module SolidusSeo
  module Jsonld
    module Core
      def to_jsonld
        @jsonld ||= jsonld.delete_if { |_, v| v.blank? }.with_indifferent_access
      end

      private

      def validate_prop(item, *required_props)
        return {} if item.blank? # ignore empty props

        required_props.map(&:to_sym).each do |req|
          item.with_indifferent_access[req].presence || report_invalid_props(req)
        end

        item
      end

      def report_invalid_props(props)
        raise "#{self.class.name} jsonld definition is missing required properties: #{Array(props).join(', ')}"
      end

      def validate_list(items, *required_props)
        Array(items).each do |it|
          validate_prop(it, *required_props)
        end
      end
    end
  end
end
