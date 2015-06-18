require 'comable_core'

require 'slim'
require 'bootstrap-sass'
require 'sass-rails'
require 'compass-rails'
require 'kaminari'

require 'jquery-rails'
require 'jquery-ui-rails'

require 'meta-tags'

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
