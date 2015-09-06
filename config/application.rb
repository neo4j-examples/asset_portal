require File.expand_path('../boot', __FILE__)

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
# require "active_record/railtie"
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'sprockets/railtie'
require 'neo4j/railtie'
require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module AssetPortal
  class Application < Rails::Application
    config.generators do |g|
      g.orm :neo4j
    end

    config.assets.precompile += %w(
      ember_apps/permissions_modal.js
      ember_apps/user_list_dropdown.js
    )

    # Configure where the embedded neo4j database should exist
    # Notice embedded db is only available for JRuby
    # config.neo4j.session_type = :embedded_db  # default #server_db
    # config.neo4j.session_path = File.expand_path('neo4j-db', Rails.root)

    # Settings in config/environments/* take precedence over those
    # specified here. Application configuration should go into files in
    # config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record
    # auto-convert to this zone. Run "rake -D time" for a list of tasks for
    # finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from
    # config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path +=
    #   Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.neo4j._active_record_destroyed_behavior = true

    neo4j_port = ENV['NEO4J_PORT']
    neo4j_url = ENV['NEO4J_URL']
    if neo4j_port.blank? && neo4j_url.blank?
      puts <<-MESSAGE
The NEO4J_PORT or NEO4J_URL environment variables are required.
The dotenv gem is installed, so you can create a
.env or .env.#{Rails.env} file to specify this.

See: https://github.com/bkeepers/dotenv
MESSAGE
      exit
    end
    config.neo4j.session_type = :server_db
    config.neo4j.session_path = neo4j_url || "http://localhost:#{neo4j_port}"
    # config.neo4j.pretty_logged_cypher_queries = true

    config.neo4j.record_timestamps = true

    config.paperclip_defaults = {
      storage: :s3,
      s3_credentials: {
        bucket: ENV['S3_BUCKET_NAME'],
        access_key_id: ENV['AWS_ACCESS_KEY_ID'],
        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
      }
    }
  end
end
