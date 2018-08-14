module SolidusSeo
  module Jsonld
    module Builder
      include SolidusSeo::Jsonld::Builder::DataMethods
      include SolidusSeo::Jsonld::Builder::BuilderMethods

      private

      def build_jsonld_with(base = {}, *props)
        props.inject(base) do |acc, it|
          builder_method = "build_#{it}_prop"
          prop_result = respond_to?(builder_method, true) && send(builder_method) || {}
          acc.merge prop_result
        end
      end

      def build_prop(prop_name, prop_data, prop_base = {})
        # ignore empty props or not yet overridden methods
        return {} if prop_data.blank?

        if prop_data.is_a? Array
          prop_data.map! { |it| it.merge prop_base }
        else
          prop_data.reverse_merge! prop_base
        end

        { prop_name.to_sym => prop_data }
      end
    end
  end
end
