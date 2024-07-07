require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SocialY
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
    # config.middleware.insert_after ActionDispatch::Callbacks, JwtAuthentication
    config.middleware.use Warden::Manager do |manager|
      manager.default_strategies :jwt
      manager.failure_app = self.routes
    end

    # Required by Devise-JWT
    config.middleware.use Warden::JWTAuth::Middleware
  end
  
end
