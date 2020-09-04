describe "Checkout complete", type: :system do
  let!(:store) { Spree::Store.default }
  let!(:taxon) { create :taxon, name: 'MyTaxon' }
  let!(:order) { create :completed_order_with_totals }
  let(:user) { Spree::User.first }
  let(:env_flag) { }

  subject { visit spree.order_path(order) }

  before do
    checkout_stubs(order)
    stub_const 'ENV', ENV.to_h.merge(env_flag => 'XXX-YYYYY')
    allow_any_instance_of(Spree::OrdersHelper).to receive(:order_just_completed?).with(order) { true }
  end

  context 'when GOOGLE_TAG_MANAGER_ID environment variable is present' do
    let(:env_flag) { 'GOOGLE_TAG_MANAGER_ID' }

    it 'renders the script to track purchase data' do
      subject
      expect(page).to have_selector :css, 'script[data-tag=google-tag-manager][data-fired-events=purchase]', visible: false
    end
  end

  context 'when GOOGLE_ANALYTICS_ID environment variable is present' do
    let(:env_flag) { 'GOOGLE_ANALYTICS_ID' }

    it 'renders the script to track purchase data' do
      subject
      expect(page).to have_selector :css, 'script[data-tag=google-analytics][data-fired-events=purchase]', visible: false
    end
  end

  context 'when FACEBOOK_PIXEL_ID environment variable is present' do
    let(:env_flag) { 'FACEBOOK_PIXEL_ID' }

    it 'renders the script to track purchase data' do
      subject
      expect(page).to have_selector :css, 'script[data-tag=facebook][data-fired-events=purchase]', visible: false
    end
  end
end
