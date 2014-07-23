module Comable
  module Proxy
    DELEGATE_METHODS = %w( === )

    EXCEPTION_FOR_RAILS_4_0_METHODS = %i( all )
    IGNORE_FOR_RAILS_4_0_METHODS = %i( build_default_scope )

    delegate(*DELEGATE_METHODS, to: :klass)

    def method_missing(method_name, *args, &block)
      if Rails::VERSION::MAJOR == 4 && Rails::VERSION::MINOR == 0
        case method_name
        when *EXCEPTION_FOR_RAILS_4_0_METHODS
          return klass.utusemi(comable_type)
        when *IGNORE_FOR_RAILS_4_0_METHODS
          return klass.send(method_name, *args, &block)
        end
      end
      klass.utusemi(comable_type).send(method_name, *args, &block)
    end

    def new(*args, &block)
      klass.new(*args, &block).utusemi!(comable_type)
    end

    def klass
      "::#{name}".constantize
    end

    def name
      method_name = "#{comable_type}_class"
      return comable_type.classify unless Comable::Engine.config.respond_to?(method_name)
      Comable::Engine.config.send(method_name).to_s
    end

    private

    def comable_type
      to_s.split('::').last.underscore
    end
  end
end
