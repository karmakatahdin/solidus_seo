# frozen_string_literal: true

describe 'Checkout complete', type: :system do
  let!(:store) { Spree::Store.default }
  let!(:taxon) { create :taxon, name: 'MyTaxon' }
  let!(:order) { create :completed_order_with_totals }
  let!(:line_item) { order.line_items.first }

  stub_authorization!

  subject { visit spree.order_path(order) }

  before do
    current_order_stubs(order)
    stub_const 'ENV', ENV.to_h.merge(env_variable => 'XXX-YYYYY')
    allow_any_instance_of(Spree::OrdersHelper).to receive(:order_just_completed?).with(order) { true }
  end

  context 'when GOOGLE_TAG_MANAGER_ID environment variable is present' do
    let(:env_variable) { 'GOOGLE_TAG_MANAGER_ID' }

    it 'tracks "purchase" event with product data' do
      subject
      expect(page).to track_analytics_event 'google-tag-manager', 'purchase', ['ecommerce', 'purchase', order.number, order.total, line_item.sku]
    end
  end

  context 'when GOOGLE_ANALYTICS_ID environment variable is present' do
    let(:env_variable) { 'GOOGLE_ANALYTICS_ID' }

    it 'tracks "purchase" event with product data' do
      subject
      expect(page).to track_analytics_event 'google-analytics', 'purchase', [
        'event', 'purchase', 'transaction_id', order.number,
        order.total, line_item.sku, line_item.variant.name,
        line_item.price, line_item.variant.options_text
      ]
    end
  end

  context 'when FACEBOOK_PIXEL_ID environment variable is present' do
    let(:env_variable) { 'FACEBOOK_PIXEL_ID' }

    it 'tracks "Purchase" event with product data' do
      subject
      expect(page).to track_analytics_event :facebook, 'purchase', ['track', 'Purchase', order.total, line_item.sku, line_item.quantity, order.number]
    end
  end

  context 'when PINTEREST_TAG_ID environment variable is present' do
    let(:env_variable) { 'PINTEREST_TAG_ID' }

    it 'tracks "checkout" event with product data' do
      subject
      expect(page).to track_analytics_event :pinterest, 'purchase', ['track', 'checkout', order.total, line_item.sku, line_item.name, line_item.price]
    end
  end
end
