module Comable
  class Engine < ::Rails::Engine
    isolate_namespace Comable

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
    end

    config.product_default_column_names = %i( name code )
  end
end
