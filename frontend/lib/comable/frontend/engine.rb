require 'comable_core'

require 'slim'

module Comable
  module Frontend
    class Engine < ::Rails::Engine
      isolate_namespace Comable

      config.generators do |g|
        g.template_engine :slim
        g.test_framework :rspec, fixture: true
        g.fixture_replacement :factory_girl, dir: 'spec/factories'
      end

      # XXX: a code below to delegate comable:install:migrations to comable_core
      config.paths['db/migrate'] = []
    end
  end
end
