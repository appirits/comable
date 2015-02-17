require 'comable_core'

require 'slim'
require 'sass-rails'
require 'coffee-rails'
require 'compass-rails'
require 'bootstrap-sass'
require 'font-awesome-rails'
require 'kaminari'
require 'ransack'

require 'jquery-rails'
require 'jquery-ui-rails'
require 'raphael-rails'
require 'morrisjs-rails'
require 'pace/rails'

module Comable
  module Backend
    class Engine < ::Rails::Engine
      # XXX: a code below to delegate comable:install:migrations to comable_core
      config.paths['db/migrate'] = []

      config.generators do |g|
        g.template_engine :slim
        g.stylesheet_engine :sass
        g.javascript_engine :coffee
        g.test_framework :rspec, fixture: true
        g.fixture_replacement :factory_girl, dir: 'spec/factories'
      end
    end
  end
end
