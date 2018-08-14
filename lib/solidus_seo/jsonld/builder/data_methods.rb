module SolidusSeo
  module Jsonld
    module Builder
      module DataMethods
        private

        # Prop-specific data source interface
        # @type attributes are unnecessary

        def address_prop
          # See https://schema.org/PostalAddress for details and examples
          # {
          #   "streetAddress": "1600 Pennsylvania Avenue",
          #   "addressLocality": "Washington",
          #   "addressRegion": "District of Columbia",
          #   "postalCode": "20500",
          #   "addressCountry": "US"
          # }
        end

        def contact_points_prop
          # See https://schema.org/ContactPoint for details and examples
          # [
          #   {
          #     "telephone": "+11111111111",
          #     "contactType": "customer service",
          #     }
          # ]
        end

        def opening_hours_specification_prop
          # See https://schema.org/OpeningHoursSpecification for details and examples
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
          # See https://schema.org/GeoCoordinates for details and examples
          # {
          #   "latitude": -37.3,
          #   "longitude": -12.68
          # }
        end

        def same_as_prop
          # See https://schema.org/SameAs for details and examples
          # [
          #   'https://facebook.com/mystore',
          #   'https://twitter.com/mystore',
          # ]
        end
      end
    end
  end
end
