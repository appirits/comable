module Comable
  module Mapper
    def method_missing(method_name, *args, &block)
      model.comable(comable_type).send(method_name, *args, &block)
    end

    def new(*args, &block)
      model.comable(comable_type).new(*args, &block)
    end

    def model
      # TODO: テーブル名とモデル名が異なるケースに対応できるよう検討
      "::#{Comable::Engine.config.send("#{comable_type}_table").to_s.classify}".constantize
    end

    private

    def comable_type
      name.split('::').last.underscore
    end
  end
end
