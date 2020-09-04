describe "Checkout complete", type: :system do
  let!(:store) { Spree::Store.default }
  let!(:taxon) { create :taxon, name: 'MyTaxon' }
  let!(:order) { create :completed_order_with_totals }
  let!(:line_item) { order.line_items.first }
  let(:user) { Spree::User.first }

  subject { visit spree.order_path(order) }

  before do
    checkout_stubs(order)
    stub_const 'ENV', ENV.to_h.merge(env_variable => 'XXX-YYYYY')
    allow_any_instance_of(Spree::OrdersHelper).to receive(:order_just_completed?).with(order) { true }
  end

  context 'when GOOGLE_TAG_MANAGER_ID environment variable is present' do
    let(:env_variable) { 'GOOGLE_TAG_MANAGER_ID' }

    it 'includes and executes a purchase event script' do
      subject

      expect(page).to matcher_for 'google-tag-manager', [order.number, order.total, 'ecommerce', 'purchase', line_item.sku, line_item.total]
    end
  end

  context 'when GOOGLE_ANALYTICS_ID environment variable is present' do
    let(:env_variable) { 'GOOGLE_ANALYTICS_ID' }

    it 'includes and executes a purchase event script' do
      subject
      expect(page).to matcher_for 'google-analytics', ['transaction_id', order.number, order.total, line_item.sku, line_item.total, 'event', 'purchase']
    end
  end

  context 'when FACEBOOK_PIXEL_ID environment variable is present' do
    let(:env_variable) { 'FACEBOOK_PIXEL_ID' }

    it 'includes and executes a purchase event script' do
      subject
      expect(page).to matcher_for :facebook, ['track', 'Purchase', order.total, line_item.sku, line_item.quantity, order.number]
    end
  end

  context 'when PINTEREST_TAG_ID environment variable is present' do
    let(:env_variable) { 'PINTEREST_TAG_ID' }

    it 'includes and executes a purchase event script' do
      subject
      expect(page).to matcher_for :pinterest, ['track', 'checkout', order.total, line_item.sku, line_item.name, line_item.price]
    end
  end
end

# Builds a regex matcher for script tag contents
# @param tag_name [String] Value of script's data-tag attribute
# @param matches [Array] Keywords that must appear in script contents (order matters!)
# @return [Object] Returns a capybara matcher for a script tag with specific attributes and contents
def matcher_for(tag_name, matches)
  matches = matches.flatten.map {|v| Regexp.escape(v.to_s) }.join('.+')
  have_selector :css, "script[data-tag=#{tag_name}][data-fired-events=purchase]", visible: false, text: /#{matches}/i
end
