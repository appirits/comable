FactoryGirl.define do
  factory :variant, class: Comable::Variant do
    price 100
    sequence(:sku) { |n| format('%07d', n.next) }
  end
end
