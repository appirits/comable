if Rails::VERSION::MAJOR > 3
  module Comable
    class Deprecator < ActiveSupport::Deprecation
      def initialize(deprecation_horizon = '0.8.0', gem_name = 'Comable')
        super
      end
    end
  end
else
  # TODO: Deprecated itself!
  module Comable
    class Deprecator
      include Singleton
    end
  end

  class Module
    def deprecate_with_deprecator(*method_names)
      options = method_names.extract_options!
      options.delete(:deprecator) if options.present?
      deprecate_without_deprecator
    end

    alias_method_chain :deprecate, :deprecator
  end
end
