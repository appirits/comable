require 'comable_core'

require 'slim'

module Comable
  module Backend
    class Engine < ::Rails::Engine
      # XXX: a code below to delegate comable:install:migrations to comable_core
      config.paths['db/migrate'] = []
    end
  end
end
