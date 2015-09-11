FactoryGirl.define do
  factory :option_type, class: Comable::OptionType do
    sequence(:name) { |n| "Option Type ##{n.next}" }
  end
end
