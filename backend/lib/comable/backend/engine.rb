require 'comable_core'

require 'slim'

module Comable
  module Backend
    class Engine < ::Rails::Engine
      isolate_namespace Comable
    end
  end
end
