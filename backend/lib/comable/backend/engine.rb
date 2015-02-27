require 'comable_core'

require 'slim'
require 'sass-rails'
require 'coffee-rails'
require 'compass-rails'
require 'bootstrap-sass'
require 'font-awesome-rails'
require 'kaminari'
require 'dynamic_form'
require 'ransack'

require 'jquery-rails'
require 'jquery-ui-rails'
require 'raphael-rails'
require 'morrisjs-rails'
require 'pace/rails'
require 'gritter'

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

      initializer 'comable.ransack.configure' do
        Ransack.configure do |config|
          config.add_predicate 'eq_any_splitted',
            arel_predicate: 'eq_any',
            formatter: proc { |v| v.split(' ') },
            validator: proc { |v| v.present? },
            compounds: false,
            type: :string

          config.add_predicate 'cont_any_splitted',
            arel_predicate: 'matches_any',
            formatter: proc { |v| v.split(' ').map { |s| "%#{s}%"} },
            validator: proc { |v| v.present? },
            compounds: false,
            type: :string
        end
      end
    end
  end
end
