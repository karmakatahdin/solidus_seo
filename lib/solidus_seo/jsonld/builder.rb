module SolidusSeo
  module Jsonld
    module Builder
      # Prop-specific data source interface

      def address_prop
        # {
        #   "streetAddress": "",
        #   "addressLocality": "",
        #   "addressRegion": "NY",
        #   "postalCode": "10019",
        #   "addressCountry": "US"
        # }
      end

      def contact_points_prop
        # [
          # {
            # "telephone": try(:telephone),
            # "contactType": "customer service",
          # }
        # ]
      end

      def opening_hours_specification_prop
        # [
          # {
          #   "dayOfWeek": [
          #     "Monday",
          #     "Tuesday"
          #     "Wednesday",
          #     "Thursday",
          #     "Friday"
          #   ],
          #   "opens": "12:00",
          #   "closes": "22:00"
          # },
          # {
          #   "dayOfWeek": "Saturday",
          #   "opens": "12:00",
          #   "closes": "23:59"
          # }
        # ]
      end

      def geo_prop
      end

      def same_as_prop
        # [
        # ]
      end


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

      # Prop-specific builder

      def build_contact_points_prop
        prop_data = validate_list(contact_points_prop, :telephone)
        build_prop(:contactPoint, prop_data, "@type": "ContactPoint", "contactType": "customer service")
      end

      def build_address_prop
        prop_data = validate_prop(address_prop, :streetAddress, :addressLocality, :addressRegion)
        build_prop(:address, prop_data, "@type": "PostalAddress")
      end

      def build_geo_prop
        prop_data = validate_prop(geo_prop, :latitude, :longitude)
        build_prop(:geo, prop_data, "@type": "GeoCoordinates")
      end

      def build_same_as_prop
        build_prop(:sameAs, validate_prop(same_as_prop))
      end

      def build_opening_hours_specification_prop
        prop_data = validate_list(opening_hours_specification_prop, :opens, :closes)
        build_prop(:openingHoursSpecification, prop_data, "@type": "OpeningHoursSpecification",)
      end
    end
  end
end
