FactoryGirl.define do
  factory :option_value, class: Comable::OptionValue do
    sequence(:name) { |n| "Option Value ##{n.next}" }
  end
end
