FactoryGirl.define do
  factory :order_item, class: Comable::OrderItem do
    sequence(:name) { |n| "test_product#{n.next}" }
    sequence(:sku) { |n| format('%07d', n.next) }
    quantity 10
    price 100
    variant { create(:variant, stock: build(:stock, quantity: quantity), product: build(:product)) }
    order { build_stubbed(:order) }

    trait :sku do
      sku_h_item_name 'カラー'
      sku_v_item_name 'サイズ'
      sku_h_choice_name 'レッド'
      sku_v_choice_name 'S'
      stock { create(:stock, :sku, :with_product, quantity: quantity) }
    end
  end
end
