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
        option_types_attributes = [name: 'Color'] + [name: 'Size'] if evaluator.sku_flag
        product = build(:product, option_types_attributes: option_types_attributes || [])

        option_values_attributes = [option_type: product.option_types.first, name: 'Red'] + [option_type: product.option_types.first, name: 'S'] if evaluator.sku_flag
        variant = build(:variant, product: product, option_values_attributes: option_values_attributes || [])

        stock.variant = variant
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
