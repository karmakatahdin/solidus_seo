# frozen_string_literal: true

module SolidusSeo
  class Engine < Rails::Engine
    require 'spree/core'

    isolate_namespace Spree
    engine_name 'solidus_seo'

    config.autoload_paths += %W(#{config.root}/lib)

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    initializer "solidus_seo.view_helpers" do
      ActiveSupport.on_load(:action_view) { ActionView::Base.send :include, Jsonld::TagHelper }
    end

    config.before_initialize do
    end

    config.after_initialize do
    end

    config.to_prepare(&method(:activate).to_proc)
  end
end
