module SolidusSeo
  module Jsonld
    module Builder
      module BuilderMethods
        private

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
end
