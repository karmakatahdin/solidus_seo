module Spree::BaseHelper
  def breadcrumb_pairs(taxon)
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

  def taxon_breadcrumbs_with_jsonld(taxon, separator = '&nbsp;&raquo;&nbsp;', list_class = 'list-inline', list_item_class = 'list-inline-item')
    return '' if current_page?('/') || taxon.nil?

    separator = tag.span(separator.html_safe, class: 'breadcrumb-separator')
    original_output = Nokogiri::HTML::DocumentFragment.parse(taxon_breadcrumbs_without_jsonld(taxon, separator, list_class).to_s)
    original_output.xpath('@itemscope|@itemtype|@itemprop|.//@itemscope|.//@itemtype|.//@itemprop').remove
    original_output.search('.columns').first['class'] = ''
    original_output.search('li').attr('class', list_item_class)

    jsonld_breadcrumbs(breadcrumb_pairs(taxon)) + original_output.to_s.html_safe
  end

  alias_method :taxon_breadcrumbs_without_jsonld, :taxon_breadcrumbs
  alias_method :taxon_breadcrumbs, :taxon_breadcrumbs_with_jsonld
end
