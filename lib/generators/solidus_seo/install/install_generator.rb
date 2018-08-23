# frozen_string_literal: true

module SolidusSeo
  module Generators
    class InstallGenerator < Rails::Generators::Base
      class_option :auto_run_migrations, type: :boolean, default: false

      source_root File.expand_path("../templates", __FILE__)

      def install_image_optim
        run 'rails generate paperclip_optimizer:install'
        copy_file 'image_optim.yml', 'config/image_optim.yml'
        copy_file 'paperclip_optimizer.rb', 'config/initializers/paperclip_optimizer.rb', force: true
      end
    end
  end
end
