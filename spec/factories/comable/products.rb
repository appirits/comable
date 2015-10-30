FactoryGirl.define do
  factory :product, class: Comable::Product do
    sequence(:name) { |n| "test_product#{n.next}" }
    published_at Date.today

    variants { [build(:variant)] }

    trait :with_stock do
      variants { [] }
      stocks { [build(:stock, :stocked, variant: variants.first)] }
    end

    trait :sku do
      after(:build) do |product|
        product.variants = [
          build(:variant, stocks: [build(:stock, :stocked)], options: [name: 'Color', value: 'Red'] + [name: 'Size', value: 'S']),
          build(:variant, stocks: [build(:stock, :stocked)], options: [name: 'Color', value: 'Red'] + [name: 'Size', value: 'M']),
          build(:variant, stocks: [build(:stock, :stocked)], options: [name: 'Color', value: 'Red'] + [name: 'Size', value: 'L'])
        ]
      end
    end

    trait :sku_h do
      after(:build) do |product|
        product.variants = [build(:variant, options: [name: 'Color', value: 'Red'])]
      end
    end
  end
end
