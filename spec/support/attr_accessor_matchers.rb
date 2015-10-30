# Based on https://gist.github.com/itspriddle/1005075/0c0548cf8b6e492987d491988806c3d6abc5fa70
RSpec::Matchers.define :have_attr_accessor do |attribute|
  match do |object|
    ['', '='].all? { |k| object.respond_to?("#{attribute}#{k}") }
  end

  description do
    "have attr_accessor :#{attribute}"
  end
end

RSpec::Matchers.define :have_attr_reader do |attribute|
  match do |object|
    object.respond_to? attribute
  end

  description do
    "have attr_reader :#{attribute}"
  end
end

RSpec::Matchers.define :have_attr_writer do |attribute|
  match do |object|
    object.respond_to? "#{attribute}="
  end

  description do
    "have attr_writer :#{attribute}"
  end
end
