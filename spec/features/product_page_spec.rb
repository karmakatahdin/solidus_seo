describe "Product page", type: :system do
  let!(:store) { Spree::Store.default }
  let(:store_seo_name) { 'My store SEO name' }

  let!(:taxon) { create(:taxon, name: 'MyTaxon') }

  let!(:product) do
    create(:base_product, taxons: [taxon])
  end

  let(:seo_image) { 'https://example.com/path/product.jpg' }
  let(:seo_name) { 'My product SEO name' }
  let(:seo_description) { 'My product SEO description' }
  let(:seo_price) { "10.00" }

  before(:each) do
    add_stubs(Spree::StoreDecorator, seo_name: store_seo_name)
    add_stubs(
      Spree::ProductDecorator,
      seo_name: seo_name,
      seo_description: seo_description,
      seo_price: seo_price,
      seo_images: [seo_image]
    )
  end

  subject { visit spree.product_path(product) }


  context 'jsonld markup output' do
    it "contains 'Store' entity type" do
      subject
      expect(page).to have_text :all, %{"@type": "Store"}
    end

    it "contains product" do
      subject
      expect(page).to have_text :all, %{"@type": "Product"}
      expect(page).to have_text :all, %{"name": "#{product.name}"}
    end

    it "contains offer" do
      subject
      expect(page).to have_text :all, %{"@type": "Offer"}
      expect(page).to have_text :all, %{"price": "#{seo_price}"}
    end
  end


  context 'page title' do
    it 'contains product SEO name' do
      subject
      expect(page.title).to include(seo_name)
    end


    context 'when store SEO name is present' do
      it "contains store SEO name" do
        subject
        expect(page.title).to include(store_seo_name)
      end
    end

    context 'when store SEO name is empty' do
      let(:store_seo_name) { '' }


      it "contains store name" do
        subject
        expect(page.title).to include(store_seo_name)
      end
    end
  end


  context 'meta tags' do
    it 'contain main product image' do
      subject
      expect(page).to have_css "link[rel=image_src][href~='#{seo_image}']", visible: false
      expect(page).to have_css "meta[property='og:image'][content~='#{seo_image}']", visible: false
    end


    it 'contain product seo_description' do
      subject
      expect(page).to have_css "meta[name=description][content='#{seo_description}']", visible: false
      expect(page).to have_css "meta[property='og:description'][content='#{seo_description}']", visible: false
    end

    it 'contain product price' do
      subject
      expect(page).to have_css "meta[property='product:price:amount'][content='#{seo_price}']", visible: false
    end
  end
end
