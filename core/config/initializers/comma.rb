# from https://github.com/comma-csv/comma/pull/50#issuecomment-22819269
Comma::HeaderExtractor.value_humanizer = lambda do |value, model_class|
  if model_class.respond_to?(:human_attribute_name)
    model_class.human_attribute_name(value)
  else
    Comma::HeaderExtractor::DEFAULT_VALUE_HUMANIZER.call(value, model_class)
  end
end

# Helper method for `comma`
class ActiveRecord::Base
  def self.comma_nested_attribute(context, hash, association = nil)
    return unless hash.is_a? Hash

    key, value = hash.first
    klass = reflect_on_association(key).klass

    if value.is_a? Hash
      klass.comma_nested_attribute(context, value, key)
    else
      block = lambda do |record| record.instance_eval("#{key}.#{value}") end
      context.send(association, klass.human_attribute_name(value), &block)
    end
  end
end
