module Comable
  class ModelMapperDefinition
    attr_accessor :model_type
    attr_accessor :klass

    def initialize(model_type)
      @model_type = model_type
      @klass = Comable.const_set(model_type.to_s.classify, build_class)
      define_acts_as_comable_model
      define_origin_class_method
    end

    def define_origin_class_method
      klass.class_eval %{
        def self.origin_class
          Comable::Engine::config.send("#{model_type}_table").to_s.classify.constantize
        end
      }
    end

    def define_acts_as_comable_model
      klass.send(:include, "Comable::ActsAsComable#{model_type.to_s.classify}::Base".constantize)
      klass.send("acts_as_comable_#{model_type}", mapping_flag: false)
    end

    def build_class
      Class.new do
        attr_reader :origin

        class << self
          def method_missing(method_name, *args, &block)
            result = self.origin_class.send(method_name, *args, &block)
            case result
            when self.origin_class
              self.new(result)
            when Array
              result.map {|obj| self.new(obj) }
            when ActiveRecord::Relation
              ActiveRecord::Relation.new(self, result.arel_table)
            else
              result
            end
          end
        end

        def initialize(*args)
          obj = args.first
          case obj
          when self.class.origin_class
            @origin = obj
          else
            @origin = self.class.origin_class.new(*args)
            super
          end
        end

        def method_missing(method_name, *args, &block)
          self.origin.send(method_name, *args, &block)
        end

        def ==(obj)
          if obj.respond_to?(:origin)
            self.origin == obj.origin
          else
            self.origin == obj
          end
        end
      end
    end
  end
end
