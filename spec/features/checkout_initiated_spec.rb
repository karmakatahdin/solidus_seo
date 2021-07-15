# frozen_string_literal: true

describe 'Checkout initated', type: :system do
  let!(:store) { create(:store) }
  let!(:taxon) { create :taxon, name: 'MyTaxon' }
  let!(:product) { create(:base_product, taxons: [taxon]) }
  let(:order) { Spree::Order.last }

  stub_authorization!

  before do
    stub_const 'ENV', ENV.to_h.merge(env_variable => 'XXX-YYYYY')
  end

  subject do
    visit spree.product_path(product)
    find('#add-to-cart-button').click
    find('#checkout-link').click
  end

  context 'when GOOGLE_TAG_MANAGER_ID environment variable is present' do
    let(:env_variable) { 'GOOGLE_TAG_MANAGER_ID' }

    it 'tracks "InitiateCheckout" event with product data' do
      skip
    end
  end

  context 'when GOOGLE_ANALYTICS_ID environment variable is present' do
    let(:env_variable) { 'GOOGLE_ANALYTICS_ID' }

    it 'tracks "InitiateCheckout" event with product data' do
      skip
    end
  end

  context 'when FACEBOOK_PIXEL_ID environment variable is present' do
    let(:env_variable) { 'FACEBOOK_PIXEL_ID' }

    it 'tracks "InitiateCheckout" event with product data' do
      subject
      expect(page).to track_analytics_event :facebook, 'initiatecheckout', ['track', 'InitiateCheckout', order.total, order.currency, order.line_items.first.sku]
    end
  end

  context 'when PINTEREST_TAG_ID environment variable is present' do
    let(:env_variable) { 'PINTEREST_TAG_ID' }

    it 'tracks "checkout" event with product data' do
      skip
    end
  end
end
