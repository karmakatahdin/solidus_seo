# encoding: UTF-8
$:.push File.expand_path('../lib', __FILE__)
require 'solidus_seo/version'

Gem::Specification.new do |s|
  s.name        = 'solidus_seo'
  s.version     = SolidusSeo::VERSION.to_s
  s.summary     = 'Enhanced SEO in Solidus'
  s.description = 'Enhanced SEO in Solidus'
  s.license     = 'BSD-3-Clause'

  s.author    = 'Karma Creative'
  s.email     = 'karma@karmacreative.io'
  s.homepage  = 'https://github.com/karmakatahdin/solidus_seo'

  s.files = Dir["{app,config,db,lib}/**/*", 'LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'solidus_core', ['>= 1.1', '< 3']
  s.add_dependency 'solidus_support'
  s.add_dependency 'meta-tags'
  s.add_dependency 'paperclip-optimizer'
  s.add_dependency 'image_optim_rails'
  s.add_dependency 'image_optim_pack'

  s.add_development_dependency 'capybara'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'poltergeist'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'sass-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_bot'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rubocop-rspec'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3'
end
