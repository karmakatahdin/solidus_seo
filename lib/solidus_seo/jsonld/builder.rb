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

        prop_data = merge_prop_data(prop_base, prop_data)

        { prop_name.to_sym => prop_data }
      end
    end

    def merge_prop_data(base_data, new_data)
      if new_data.respond_to? :reverse_merge # Hash
        new_data.reverse_merge base_data
      elsif new_data.respond_to? :map # Array
        new_data.map { |it| merge_prop_data(base_data, it) }
      else # Scalar, pass it through
        new_data
      end
    end
  end
end
