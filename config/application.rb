require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
# require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
require "rails/test_unit/railtie"
require 'csv'
require 'iconv'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Grappes
  class Application < Rails::Application

    config.time_zone = 'Paris'
    config.i18n.default_locale = :fr

    config.assets.enabled = true
    config.assets.initialize_on_precompile = false
    config.assets.precompile += ['rails_admin/rails_admin.css', 'rails_admin/rails_admin.js']
    config.serve_static_assets = true
  end
end
