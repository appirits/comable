FactoryGirl.define do
  factory :order_detail, class: Comable::OrderDetail do
    sequence(:name) { |n| "test_product#{n.next}" }
    sequence(:code) { |n| format('%07d', n.next) }
    quantity 10
    price 100
    stock { create(:stock, :with_product, quantity: quantity) }
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
