# Helper methods for `comma` method
Comma::Extractor.class_eval do
  def __association__(hash)
    return unless hash.is_a? Hash

    association = hash.keys.first
    method_path = hash_to_method_path(hash)

    block = -> (record) { method_path[1..-1].inject(record, &:send) }
    klass = @instance.is_a?(ActiveRecord::Base) ? @instance.class : @instance
    send(association, nested_human_attribute_name(klass, method_path), &block)
  end

  private

  # { foo: { bar: :sample } } => [:foo, :bar, :sample]
  def hash_to_method_path(hash)
    key, value = hash.first
    value = value.is_a?(Hash) ? hash_to_method_path(value) : [value]
    [key] + value
  end

  # [:foo, :bar, :sample] => "Foo/Bar/Sample"
  def nested_human_attribute_name(klass, method_path)
    method_name = method_path.first
    return unless method_name
    association = klass.reflect_on_association(method_name).try(:klass) || klass
    human_method_name = klass.human_attribute_name(method_name)
    [human_method_name, nested_human_attribute_name(association, method_path[1..-1])].compact.join('/')
  end
end
