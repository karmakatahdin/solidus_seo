# frozen_string_literal: true

describe 'Add to cart', type: :system do
  let!(:store) { create(:store) }
  let!(:product) { create(:product) }
  let(:line_item_quantity) { 2 }
  let(:order) { Spree::Order.last }
  let(:line_item) { order.line_items.first }

  stub_authorization!

  before do
    stub_const 'ENV', ENV.to_h.merge(env_variable => 'XXX-YYYYY')

    visit spree.product_path(product)
    fill_in('quantity', with: line_item_quantity)
    find('#add-to-cart-button').click
  end

  context 'when FACEBOOK_PIXEL_ID environment variable is present' do
    let(:env_variable) { 'FACEBOOK_PIXEL_ID' }

    it 'tracks "add to cart" event with product data' do
      expect(page).to track_analytics_event :facebook, 'addtocart', [
        'fbq', 'track', 'AddToCart', line_item.amount, line_item.sku
      ]
    end
  end

  context 'when PINTEREST_TAG_ID environment variable is present' do
    let(:env_variable) { 'PINTEREST_TAG_ID' }

    it 'tracks "add to cart" event' do
      expect(page).to track_analytics_event :pinterest, 'addtocart', [
        'track', 'addtocart', line_item.amount, order.number, line_item.product.sku,
        line_item.name, line_item.sku, line_item.price
      ]
    end

    it 'skips printing a flash message to the user with added_to_cart raw data' do
      expect(page).to_not have_css '.flash.added_to_cart'
    end
  end
end

