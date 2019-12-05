require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
# require "rails/test_unit/railtie"

require_relative '../lib/log/log_formatter'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ServiceDeskBackend
  class Application < Rails::Application
    Dotenv::Railtie.load

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.time_zone = 'Krasnoyarsk'
    config.active_record.default_timezone = :local
    config.i18n.default_locale = :ru

    config.autoload_paths << Rails.root.join('lib', 'strategies').to_s
    config.autoload_paths << Rails.root.join('lib', 'external_services').to_s
    config.autoload_paths << Rails.root.join('lib', 'resources').to_s
    config.autoload_paths << Rails.root.join('lib', 'decorators').to_s
    config.autoload_paths << Rails.root.join('lib', 'modules').to_s
    config.autoload_paths << Rails.root.join('lib', 'values').to_s
    config.autoload_paths << Rails.root.join('lib', 'queries').to_s
    config.autoload_paths << Rails.root.join('lib', 'log').to_s
    config.autoload_paths << Rails.root.join('lib', 'states').to_s
    config.autoload_paths << Rails.root.join('lib', 'validators').to_s
    config.autoload_paths << Rails.root.join('lib', 'services').to_s
    config.autoload_paths << Rails.root.join('lib', 'factories').to_s

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    config.generators do |g|
      g.orm :active_record
      g.test_framework :rspec,
                       fixtures: true,
                       routing_specs: false,
                       request_specs: false,
                       controller_spec: true
      g.fixture_replacement :factory_bot, dir: 'spec/factories'
    end

    config.log_formatter = MessageFormatter.new
    config.action_cable.disable_request_forgery_protection = true
    config.active_job.queue_adapter = :sidekiq
    config.action_mailer.perform_deliveries = true
  end
end
