config_file_path = Rails.root.join('config', 'image_optim.yml')
# Processor will be disabled if config/image_optim.yml is not found -> https://goo.gl/YQxtUv
if Rails.env.production? && File.exist?(config_file_path)
  Paperclip::PaperclipOptimizer.default_options = YAML.load_file(config_file_path)
end
