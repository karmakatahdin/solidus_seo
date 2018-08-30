module SolidusSeo
  module Helpers
    module BaseHelper
      def plain_text(text)
        ActionController::Base.helpers.strip_tags(text.to_s).gsub(/\s+/, ' ')
      end

      def breadcrumb_pairs(taxon)
        return '' if current_page?('/') || taxon.nil?

        crumbs = []

        if taxon
          crumbs << [Spree.t(:products), products_url]
          crumbs += taxon.ancestors.collect { |a| [a.name, spree.nested_taxons_url(a.permalink)] } unless taxon.ancestors.empty?
          crumbs << [taxon.name, spree.nested_taxons_url(taxon.permalink)]
        else
          crumbs << [Spree.t(:products), products_url]
        end

        crumbs
      end
    end
  end
end
