# from https://github.com/comma-csv/comma/pull/50#issuecomment-22819269
Comma::HeaderExtractor.value_humanizer = lambda do |value, model_class|
  if model_class.respond_to?(:human_attribute_name)
    model_class.human_attribute_name(value)
  else
    Comma::HeaderExtractor::DEFAULT_VALUE_HUMANIZER.call(value, model_class)
  end
end
