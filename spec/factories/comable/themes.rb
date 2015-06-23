FactoryGirl.define do
  factory :theme, class: Comable::Theme do
    sequence(:name) { |n| "theme_#{n}" }
    sequence(:display) { |n| "Theme ##{n}" }
    version '0.1.0'
    description 'This is the example.'
    homepage 'http://www.example.com'
    author 'John'
  end
end
