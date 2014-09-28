FactoryGirl.define do
  factory :order_detail, class: Comable::OrderDetail do
    name 'test_product'
    code '1234567'
    quantity 10
    price 100
    stock { build(:stock, :unsold, :with_product) }
    order_delivery { FactoryGirl.build_stubbed(:order_delivery) }

    trait :many do
      sequence(:name) { |n| "test_product#{n.next}" }
      sequence(:code) { |n| format('%07d', n.next) }
    end

    trait :sku do
      sku_h_item_name 'カラー'
      sku_v_item_name 'サイズ'
      sku_h_choice_name 'レッド'
      sku_v_choice_name 'S'
      stock { build(:stock, :sku, :unsold, :with_product) }
    end
  end
end
