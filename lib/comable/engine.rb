require 'slim'

module Comable
  class Engine < ::Rails::Engine
    isolate_namespace Comable
  end
end
