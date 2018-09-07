require 'spec_helper'

describe "Taxon page", type: :feature do
  let!(:store) do
    add_stubs :store, seo_name: seo_name,
                      seo_image: seo_image,
                      seo_description: seo_description
  end
  let(:seo_name) { 'My store SEO name' }
  let(:seo_image) { 'https://example.com/path/store.jpg' }
  let(:seo_description) { 'My store SEO description' }


  let!(:taxon) { create(:taxon, name: 'MyTaxon') }
  let!(:product) { create(:base_product, taxons: [taxon]) }

  before :each do
    allow(store).to receive(:seo_image) { seo_image }
  end

  subject { visit spree.nested_taxons_path(taxon) }


  context 'jsonld markup output' do
    it "contains organization" do
      subject
      expect(page).to have_text :all, %{"@type": "Organization"}
    end

    it "contains breadcrumb list" do
      subject
      expect(page).to have_text :all, %{"@type": "BreadcrumbList"}
    end

    it "contains item list" do
      subject
      expect(page).to have_text :all, %{"@type": "ItemList"}
    end
  end


  context 'page title' do
    it "contains taxon's name" do
      subject
      expect(page.title).to include(taxon.name)
    end


    context 'when store SEO name is present' do
      it "contains store SEO name" do
        subject
        expect(page.title).to include(seo_name)
      end
    end

    context 'when store SEO name is empty' do
      let(:seo_name) { '' }

      it "contains store name" do
        subject
        expect(page.title).to include(seo_name)
      end
    end
  end


  context 'meta tags' do
    it 'contain store main image when present' do
      subject
      expect(page).to have_css "link[rel=image_src][href~='#{seo_image}']", visible: false
      expect(page).to have_css "meta[property='og:image'][content~='#{seo_image}']", visible: false
    end

    it 'contain store description when present' do
      subject
      expect(page).to have_css "meta[name=description][content='#{seo_description}']", visible: false
      expect(page).to have_css "meta[property='og:description'][content='#{seo_description}']", visible: false
    end
  end


  context 'when taxon has subtaxons with products' do
    before(:each) do
      subtaxon1 = create(:taxon, name: 'Subtaxon1', parent: taxon)
      subtaxon2 = create(:taxon, name: 'Subtaxon2', parent: taxon)
      subprod1 = create(:base_product, name: 'Subprod1', taxons: [subtaxon1])
      subprod2 = create(:base_product, name: 'Subprod1', taxons: [subtaxon2])
    end


    it 'only prints one ItemList despite showing multiple subtaxons products' do
      subject
      expect(page).to have_text :all, %{"@type": "ItemList"}, count: 1
    end
  end
end
