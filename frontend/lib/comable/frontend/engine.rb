require 'comable_core'

require 'slim'
require 'jquery-rails'
require 'bootstrap-sass'

# TODO: Enable after solve the issue.
# refs https://github.com/Compass/compass-rails/issues/155
# require 'compass-rails'

module Comable
  module Frontend
    class Engine < ::Rails::Engine
      config.generators do |g|
        g.template_engine :slim
        g.test_framework :rspec, fixture: true
        g.fixture_replacement :factory_girl, dir: 'spec/factories'
      end

      # XXX: a code below to delegate comable:install:migrations to comable_core
      config.paths['db/migrate'] = []

      config.autoload_paths << "#{config.root}/app/controllers/concerns" if Rails::VERSION::MAJOR == 3
    end
  end
end
