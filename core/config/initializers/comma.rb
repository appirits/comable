# from https://github.com/comma-csv/comma/pull/50#issuecomment-22819269
Comma::HeaderExtractor.value_humanizer = lambda do |value, model_class|
  if value.is_a?(String) || !model_class.respond_to?(:human_attribute_name)
    Comma::HeaderExtractor::DEFAULT_VALUE_HUMANIZER.call(value, model_class)
  else
    model_class.human_attribute_name(value)
  end
end
