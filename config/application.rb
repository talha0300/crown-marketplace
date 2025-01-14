require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
# require 'action_mailbox/engine'
# require 'action_text/engine'
require 'action_mailer/railtie'
require 'action_view/railtie'
# require "action_cable/engine"
require 'sprockets/railtie'
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Marketplace
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    # config.load_defaults 5.2
    config.load_defaults 6.0

    Rails.autoloaders.main.ignore(Rails.root.join('storage'))

    config.autoload_paths += %W[#{config.root}/app/workers #{config.root}/storage]

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Don't generate system test files.
    config.generators.system_tests = nil

    config.action_controller.include_all_helpers = false

    config.action_dispatch.default_headers = {
      'X-Frame-Options' => 'DENY',
      'X-XSS-Protection' => '1; mode=block',
      'X-Content-Type-Options' => 'nosniff',
      'Strict-Transport-Security' => 'max-age=31536000',
      'Server' => ' '
    }

    # config.action_dispatch.default_headers.merge!('X-Content-Type-Options' => 'nosniff')

    extend Sprockets::BumbleD::DSL

    configure_sprockets_bumble_d do |config|
      config.babel_config_version = 1
    end

    config.i18n.default_locale = :en

    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]

    # do not add field-with-error div anymore
    ActionView::Base.field_error_proc = proc do |html_tag, _instance|
      html_tag
    end

    config.active_job.queue_adapter = :sidekiq unless Rails.env.test?

    config.exceptions_app = routes
  end

  def self.feedback_email_address
    'info@crowncommercial.gov.uk'
  end

  def self.support_form_link
    'https://www.crowncommercial.gov.uk/contact'
  end

  def self.fm_survey_link
    ENV['FM_SURVEY_LINK']
  end

  def self.support_telephone_number
    '0345 410 2222'
  end

  def self.ccs_homepage_url
    'https://www.crowncommercial.gov.uk/'
  end

  # :nocov:
  def self.http_basic_auth_name
    @http_basic_auth_name ||= ENV.fetch('HTTP_BASIC_AUTH_NAME')
  end

  def self.http_basic_auth_password
    @http_basic_auth_password ||= ENV.fetch('HTTP_BASIC_AUTH_PASSWORD')
  end

  # :nocov:

  def self.google_analytics_tracking_id
    @google_analytics_tracking_id ||= ENV.fetch('GA_TRACKING_ID', nil)
  end

  def self.google_tag_manager_tracking_id
    @google_tag_manager_tracking_id ||= ENV.fetch('GTM_TRACKING_ID', nil)
  end

  def self.google_geocoding_api_key
    @google_geocoding_api_key ||= ENV.fetch('GOOGLE_GEOCODING_API_KEY')
  end

  def self.dfe_signin_url
    @dfe_signin_url ||= ENV['DFE_SIGNIN_URL']
  end

  def self.dfe_signin_enabled?
    dfe_signin_url.present?
  end

  def self.supply_teachers_cognito_enabled?
    ENV.key?('SUPPLY_TEACHERS_COGNITO_ENABLED')
  end

  def self.dfe_signin_uri
    return unless dfe_signin_enabled?

    # Workaround for env var value including quotes in test environment
    URI.parse(dfe_signin_url.sub(/^"/, '').sub(/"$/, ''))
  end

  def self.dfe_signin_client_id
    @dfe_signin_client_id ||= ENV.fetch('DFE_SIGNIN_CLIENT_ID')
  end

  def self.dfe_signin_client_secret
    @dfe_signin_client_secret ||= ENV.fetch('DFE_SIGNIN_CLIENT_SECRET')
  end

  def self.dfe_signin_redirect_uri
    @dfe_signin_redirect_uri ||= ENV.fetch('DFE_SIGNIN_REDIRECT_URI')
  end

  def self.dfe_signin_safelist_enabled?
    ENV['DFE_SIGNIN_WHITELISTED_EMAIL_ADDRESSES'].present?
  end

  def self.dfe_signin_safelisted_email_addresses
    return unless dfe_signin_safelist_enabled?

    @dfe_signin_safelisted_email_addresses ||= ENV['DFE_SIGNIN_WHITELISTED_EMAIL_ADDRESSES'].split(',')
  end

  def self.upload_privileges?
    ENV['APP_HAS_UPLOAD_PRIVILEGES'].present?
  end

  def self.rails_env_url
    @rails_env_url ||= ENV.fetch('RAILS_ENV_URL')
  end

  def self.can_edit_facilities_management_frameworks?
    @can_edit_facilities_management_frameworks ||= rails_env_url != 'https://marketplace.service.crowncommercial.gov.uk'
  end

  def self.rm6232_live?
    @rm6232_live ||= Time.now.in_time_zone('London') >= Time.new(2022, 7, 18, 11).in_time_zone('London')
  end

  def self.cookie_settings_name
    :crown_marketplace_cookie_options_v1
  end

  def self.default_cookie_options
    {
      settings_viewed: false,
      google_analytics_enabled: false,
      glassbox_enabled: false
    }.stringify_keys
  end
end
