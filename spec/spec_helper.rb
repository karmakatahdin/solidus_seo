# frozen_string_literal: true

# Run Coverage report
require 'simplecov'

SimpleCov.start do
  add_filter 'spec/dummy'
  add_group 'Controllers', 'app/controllers'
  add_group 'Helpers', 'app/helpers'
  add_group 'Mailers', 'app/mailers'
  add_group 'Models', 'app/models'
  add_group 'Views', 'app/views'
  add_group 'Libraries', 'lib'
end

# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

require File.expand_path('dummy/config/environment.rb', __dir__)

require 'pry-byebug'
require 'awesome_print'
require 'rspec/rails'
require 'ffaker'
require 'factory_bot'

require "solidus_dev_support/rspec/feature_helper"
require "solidus_dev_support/rspec/rails_helper"
require "solidus_dev_support/rspec/spec_helper"

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each { |f| require f }

# Requires factories and other useful helpers defined in spree_core.
require 'spree/testing_support/authorization_helpers'
require 'spree/testing_support/capybara_ext'
require 'spree/testing_support/controller_requests'
require 'spree/testing_support/factories'
require 'spree/testing_support/url_helpers'

require 'system_helper'

require_dependency 'solidus_seo/factories'

Capybara.register_driver :apparition do |app|
  Capybara::Apparition::Driver.new(
    app,
    debug: ENV['JS_DEBUG'].present?,
    js_errors: ENV['JS_DEBUG'].present?,
    inspector: ENV['JS_DEBUG'].present?
  )
end
# As long as we have only have features
Capybara.default_driver = :apparition

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.include TestingHelpers
  config.include Spree::TestingSupport::UrlHelpers

  config.expose_dsl_globally = true
  config.infer_spec_type_from_file_location!
  config.mock_with :rspec
  config.use_transactional_fixtures = true
  config.color = true
  config.fail_fast = ENV['FAIL_FAST'] || false
  config.order = 'random'
  # config.filter_rails_from_backtrace!

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
end
