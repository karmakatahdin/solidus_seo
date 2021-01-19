# frozen_string_literal: true
RSpec.configure do |c|
  Capybara.disable_animation = true

  c.before(:example, type: :system) do
    driven_by ENV['DEBUG_CAPYBARA'] ? :selenium_chrome : :selenium_chrome_headless
  end

  c.when_first_matching_example_defined(type: :system) do
    c.before :suite do
      # Preload assets
      if Rails.application.respond_to?(:precompiled_assets)
        Rails.application.precompiled_assets
      end
    end
  end
end
