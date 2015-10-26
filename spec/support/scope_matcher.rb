# Based on http://stackoverflow.com/questions/6853744/how-can-i-have-rspec-test-for-my-default-scope/6853925#6853925
RSpec::Matchers.define :scope do |scope|
  define_method :actual_for do |subject|
    subject.class.send(scope).to_sql
  end

  define_method :expected_for do |subject|
    subject.class.instance_eval(&block_arg).to_sql
  end

  define_method :diff do |actual, expected|
    RSpec::Support::Differ.new.diff_as_string(actual.split.join("\n"), expected.split.join("\n"))
  end

  match do |subject|
    actual_for(subject) == expected_for(subject)
  end

  failure_message do |subject|
    expected = expected_for(subject)
    actual = actual_for(subject)
    "expected the scope as `#{expected}`, but builds `#{actual}`" + diff(actual, expected)
  end
end
