module Comable
  module Backend
    class Engine < ::Rails::Engine
      isolate_namespace Comable::Backend
    end
  end
end
