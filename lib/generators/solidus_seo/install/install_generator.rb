# frozen_string_literal: true

module SolidusSeo
  module Generators
    class InstallGenerator < Rails::Generators::Base
      class_option :auto_run_migrations, type: :boolean, default: false

      source_root File.expand_path("../templates", __FILE__)

      def install_image_optim
        run 'bundle exec rails g paperclip_optimizer:install'
        copy_file 'image_optim.yml', 'config/image_optim.yml'
        copy_file 'paperclip_optimizer.rb', 'config/initializers/paperclip_optimizer.rb', force: true
      end

      def install_overrides
        if ENV["RAILS_ENV"] == "test"
          overrides_choice == "y"
        else
          overrides_choice = ask("Do you want to install the solidus_seo deface overrides into your app?", limited_to: ["y", "n"])
        end
        if (overrides_choice == "y")
          copy_file 'insert_dump_jsonld_helper.html.erb.deface', 'app/overrides/spree/layouts/spree_application/insert_dump_jsonld_helper.html.erb.deface'
          copy_file 'insert_product_jsonld_helper.html.erb.deface', 'app/overrides/spree/products/show/insert_product_jsonld_helper.html.erb.deface'
          copy_file 'insert_display_meta_tags_helper.html.erb.deface', 'app/overrides/spree/shared/_head/insert_display_meta_tags_helper.html.erb.deface'
          copy_file 'remove_original_title_tag.deface', 'app/overrides/spree/shared/_head/remove_original_title_tag.deface'
          copy_file 'insert_product_list_helper.html.erb.deface', 'app/overrides/spree/shared/_products/insert_product_list_helper.html.erb.deface'
        end
      end
    end
  end
end
