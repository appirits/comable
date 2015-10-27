FactoryGirl.define do
  factory :stock, class: Comable::Stock do
    variant_id 0
    quantity 0

    transient { sku_flag false }

    trait :sku do
      transient { sku_flag true }
    end

    trait :with_product do
      after(:create) do |stock, evaluator|
        options = [name: 'Color', value: 'Red'] + [name: 'Size', value: 'S'] if evaluator.sku_flag
        product = build(:product)
        variant = build(:variant, product: product, options: options || [])
        stock.update(variant: variant)
      end
    end

    trait :unstocked do
      quantity 0
    end

    trait :stocked do
      quantity 10
    end
  end
end
