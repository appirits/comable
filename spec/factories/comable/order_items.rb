FactoryGirl.define do
  factory :order_item, class: Comable::OrderItem do
    sequence(:name) { |n| "test_product#{n.next}" }
    sequence(:sku) { |n| format('%07d', n.next) }
    quantity 10
    price 100
    variant { create(:variant, stocks: [build(:stock, quantity: quantity)], product: build(:product)) }
    order { build_stubbed(:order) }

    trait :sku do
      after(:build) do |order_item|
        product = order_item.variant.try(:product) || build(:product)
        variant = order_item.variant || build(:variant)
        variant.product = product
        variant.stocks = [build(:stock, quantity: order_item.quantity)] if variant.stocks
        variant.options = [name: 'Color', value: 'Red'] + [name: 'Size', value: 'S']

        order_item.variant = variant
      end
    end
  end
end
