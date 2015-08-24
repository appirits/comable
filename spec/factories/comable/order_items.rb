FactoryGirl.define do
  factory :order_item, class: Comable::OrderItem do
    sequence(:name) { |n| "test_product#{n.next}" }
    sequence(:sku) { |n| format('%07d', n.next) }
    quantity 10
    price 100
    variant { create(:variant, stock: build(:stock, quantity: quantity), product: build(:product)) }
    order { build_stubbed(:order) }

    trait :sku do
      after(:build) do |order_item|
        product = order_item.variant.try(:product) || build(:product)
        product.option_types_attributes = [name: 'Color'] + [name: 'Size']

        variant = order_item.variant || build(:variant)
        variant.product = product
        variant.stock = build(:stock, quantity: order_item.quantity) if variant.stock
        variant.option_values_attributes = [option_type: product.option_types.first, name: 'Red'] + [option_type: product.option_types.first, name: 'S']

        order_item.variant = variant
      end
    end
  end
end
