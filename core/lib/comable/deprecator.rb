module Comable
  class Deprecator < ActiveSupport::Deprecation
    def initialize(deprecation_horizon = '0.4.0', gem_name = 'Comable')
      super
    end
  end
end
