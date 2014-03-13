module Comable
  class ModelMapperDefinition
    attr_accessor :model_type
    attr_accessor :klass

    def initialize(model_type)
      @model_type = model_type
      @klass = Comable.const_set(model_type.to_s.classify, mapping? ? build_mapper_class : build_model_class)
      include_acts_as_comable_model
      define_mapping_class_method
      define_origin_class_method if mapping?
    end

    def mapping?
      Comable::Engine::config.respond_to?("#{model_type}_table")
    end

    def nonmapping?
      not mapping?
    end

    def include_acts_as_comable_model
      klass.send(:include, "Comable::ActsAsComable#{model_type.to_s.classify}::Base".constantize)
      klass.send("acts_as_comable_#{model_type}", model_class_flag: nonmapping?)
    end

    def define_mapping_class_method
      klass.class_eval %{
        def self.mapping?
          #{mapping?}
        end
      }
    end

    def define_origin_class_method
      klass.class_eval %{
        def self.origin_class
          Comable::Engine::config.send("#{model_type}_table").to_s.classify.constantize
        end
      }
    end

    def build_model_class
      Class.new(ActiveRecord::Base) do
        class << self
          def origin_class
            self
          end
        end

        def origin
          self
        end
      end
    end

    def build_mapper_class
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
