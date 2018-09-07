# frozen_string_literal: true
# require 'spree/testing_support/factories/store_factory.rb'
FactoryBot.define do
  # Define your Spree extensions Factories within this file to enable applications, and other extensions to use and override them.
  #
  # Example adding this to your spec_helper will load these Factories for use:
  # require 'solidus_seo/factories'
end

FactoryBot.modify do
  factory :store, class: Spree::Store do
    seo_title { 'My Store SEO name' }
    meta_description { 'My Store SEO description' }
  end

  factory :base_product, class: Spree::Product do
    meta_description { 'My Product SEO description' }
  end
end
