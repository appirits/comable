module Comable
  module Mapper
    EXCEPTION_FOR_RAILS_4_0_METHODS = %i( all )
    IGNORE_FOR_RAILS_4_0_METHODS = %i( build_default_scope )

    def method_missing(method_name, *args, &block)
      if Rails::VERSION::MAJOR == 4 && Rails::VERSION::MINOR == 0
        case method_name
        when *EXCEPTION_FOR_RAILS_4_0_METHODS
          return model.comable(comable_type)
        when *IGNORE_FOR_RAILS_4_0_METHODS
          return model.send(method_name, *args, &block)
        end
      end
      model.comable(comable_type).send(method_name, *args, &block)
    end

    def new(*args, &block)
      model.comable(comable_type).new(*args, &block)
    end

    def model
      # TODO: テーブル名とモデル名が異なるケースに対応できるよう検討
      "::#{Comable::Engine.config.send("#{comable_type}_table").to_s.classify}".constantize
    end

    def foreign_key
      "#{model_name.singular}_id"
    end

    private

    def comable_type
      name.split('::').last.underscore
    end
  end
end
