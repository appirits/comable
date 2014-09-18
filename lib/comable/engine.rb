module Comable
  class Engine < ::Rails::Engine
    isolate_namespace Comable

    # XXX: a code below to delegate comable:install:migrations to comable_core
    config.paths['db/migrate'] = []
  end
end
