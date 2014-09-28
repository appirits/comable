module Comable
  module Core
    class Engine < ::Rails::Engine
      isolate_namespace Comable

      config.generators do |g|
        g.test_framework :rspec, fixture: true
        g.fixture_replacement :factory_girl, dir: 'spec/factories'
      end

      config.autoload_paths << "#{config.root}/app/models/concerns" if Rails::VERSION::MAJOR == 3
    end
  end
end
