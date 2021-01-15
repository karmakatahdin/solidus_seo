# frozen_string_literal: true
require_dependency 'solidus_seo/jsonld/tag_helper'
require_dependency 'solidus_seo/helpers/base_helper'

module SolidusSeo
  class Engine < Rails::Engine
    require 'spree/core'

    isolate_namespace Spree
    engine_name 'solidus_seo'

    include ::SolidusSupport::EngineExtensions

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    def self.activate
    end

    initializer "solidus_seo.view_helpers" do
      ActiveSupport.on_load(:action_view) do
        ActionView::Base.send :include, ::SolidusSeo::Jsonld::TagHelper
        ActionView::Base.send :include, ::SolidusSeo::Helpers::BaseHelper
      end
    end

    config.before_initialize do
    end

    config.after_initialize do
    end

    config.to_prepare(&method(:activate).to_proc)
  end
end
