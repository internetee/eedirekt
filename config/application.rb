require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Eedirect
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.i18n.available_locales = %i[et en]
    config.i18n.default_locale = :en

    config.generators do |g|
      g.helper false
      g.test_framework  :rspec, :fixture => false
      g.view_specs      false
      g.helper_specs    false
      g.fixture_replacement :fabrication
    end

    config.exceptions_app = ->(env) { ErrorsController.action(:show).call(env) }
  end
end
