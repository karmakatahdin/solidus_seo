# frozen_string_literal: true

describe 'Add to cart', type: :system do
  let!(:store) { Spree::Store.default }
  let!(:order) { create :completed_order_with_totals }
  let!(:line_item) { order.line_items.first }

  stub_authorization!

  before do
    current_order_stubs(order)
    stub_const 'ENV', ENV.to_h.merge(env_variable => 'XXX-YYYYY')

    visit spree.product_path(line_item.product)
    find('#add-to-cart-button').click
  end

  context 'when PINTEREST_TAG_ID environment variable is present' do
    let(:env_variable) { 'PINTEREST_TAG_ID' }

    it 'tracks "add to cart" event' do
      expect(page).to track_analytics_event :pinterest, 'addtocart', [
        'track', 'addtocart', order.total, order.number, line_item.variant.product.master.sku,
        line_item.name, line_item.variant.sku, line_item.variant.price
      ]
    end

    it 'skips printing a flash message to the user with added_to_cart raw data' do
      expect(page).to_not have_css '.flash.added_to_cart'
    end
  end
end

