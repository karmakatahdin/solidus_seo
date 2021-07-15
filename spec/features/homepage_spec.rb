describe "Homepage", type: :system do
  let!(:store) { create(:store) }
  let(:seo_name) { 'My store SEO name' }
  let(:seo_image) { 'https://example.com/path/store.jpg' }
  let(:seo_description) { 'My store SEO description' }
  let(:seo_tagline) { 'This is a tagline' }

  before :each do
    add_stubs(
      Spree::StoreDecorator,
      name: 'My Store',
      seo_name: seo_name,
      seo_image: seo_image,
      seo_description: seo_description,
      seo_tagline: seo_tagline
    )
  end

  subject { visit spree.root_path }


  context 'jsonld markup output' do
    it "contains 'Store' entity type" do
      subject
      expect(page).to have_text :all, %{"@type": "Store"}
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

  context 'noscript tags' do
    context 'when GOOGLE_TAG_MANAGER_ID is present' do
      let(:env_variable) { 'GOOGLE_TAG_MANAGER_ID' }

      before do
        stub_const 'ENV', ENV.to_h.merge(env_variable => 'XXX-YYYYY')
      end

      it 'contains noscript tag for GTM' do
        subject
        expect(page).to have_text :all, "https://www.googletagmanager.com/ns.html"
      end
    end
  end
end
