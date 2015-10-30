FactoryGirl.define do
  factory :variant, class: Comable::Variant do
    price 100
    sequence(:sku) { |n| format('%07d', n.next) }

    trait :with_product do
      product
    end

    trait :with_stock do
      stocks { [build(:stock)] }
    end
  end
end
