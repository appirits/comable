module Comable
  module EngineControllerTestMonkeyPatch
    def self.included(base)
      base.routes { Comable::Core::Engine.routes }
    end
  end
end
