require 'comable_core'

require 'slim'
require 'sass-rails'
require 'coffee-rails'
require 'compass-rails'
require 'bootstrap-sass'
require 'font-awesome-rails'
require 'kaminari'
require 'ransack'

require 'rails-assets-jquery'
require 'rails-assets-jquery-ujs'
require 'rails-assets-jstree'
require 'rails-assets-raphael'
require 'rails-assets-morris'
require 'rails-assets-pace'

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
