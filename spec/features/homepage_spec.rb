require 'spec_helper'

describe "Homepage", type: :feature do
  let!(:store) do
    add_stubs :store, seo_name: seo_name,
                      seo_image: seo_image,
                      seo_description: seo_description
  end
  let(:seo_name) { 'My store SEO name' }
  let(:seo_image) { 'https://example.com/path/store.jpg' }
  let(:seo_description) { 'My store SEO description' }

  before :each do
    allow(store).to receive(:seo_image) { seo_image }
  end

  subject { visit spree.root_path }


  context 'jsonld markup output' do
    it "contains organization" do
      subject
      expect(page).to have_text :all, %{"@type": "Organization"}
    end

    it "contains store name" do
      subject
      expect(page).to have_text :all, %{"name": "#{store.name}"}
    end
  end


  context 'page title' do
    it "contains store SEO name" do
      subject
      expect(page.title).to include(seo_name)
    end

    it "contains store SEO tagline" do
      subject
      expect(page.title).to include(store.seo_tagline)
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
end
