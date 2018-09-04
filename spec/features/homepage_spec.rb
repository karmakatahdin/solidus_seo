require 'spec_helper'

describe "Homepage", type: :feature do
  let!(:store) { create(:store) }
  before(:each) do
    visit spree.root_path
  end

  it "has store jsonld markup" do
    # expect(page).to have_css("script[type]")
  end
end
