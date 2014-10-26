module Comable
  module Core
    class Engine < ::Rails::Engine
      isolate_namespace Comable

      config.generators do |g|
        g.test_framework :rspec, fixture: true
        g.fixture_replacement :factory_girl, dir: 'spec/factories'
      end

      config.autoload_paths << "#{config.root}/app/models/concerns" if Rails::VERSION::MAJOR == 3

      initializer 'comable.congiguration', before: :load_config_initializers do |app|
        app.config.comable = Comable::Core::Configuration
        Comable::Config = app.config.comable
      end

      # refs: https://github.com/plataformatec/devise/wiki/How-To:-Use-devise-inside-a-mountable-engine
      initializer 'comable.devise.setup', before: :load_config_initializers do
        Devise.setup do |config|
          config.mailer_sender = 'comable@example.com'

          require 'devise/orm/active_record'

          config.case_insensitive_keys = [:email]
          config.strip_whitespace_keys = [:email]
          config.skip_session_storage = [:http_auth]
          config.stretches = Rails.env.test? ? 1 : 10
          config.reconfirmable = true
          config.password_length = 8..128
          config.reset_password_within = 6.hours
          config.sign_out_via = :delete

          # ==> Mountable engine configurations
          config.router_name = :comable
          config.parent_controller = 'Comable::ApplicationController'
        end
      end
    end
  end
end
