# frozen_string_literal: true
RSpec.configure do |config|
  config.when_first_matching_example_defined(type: :system) do
    config.before :suite do
      # Preload assets
      if Rails.application.respond_to?(:precompiled_assets)
        Rails.application.precompiled_assets
      end
    end

    config.before(:example, type: :system) do
      driven_by :apparition
    end
  end
end
