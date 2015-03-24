FactoryGirl.define do
  factory :product, class: 'Comable::Product' do
    sequence(:name) { |n| "test_product#{n.next}" }
    sequence(:code) { |n| format('%07d', n.next) }
    price 100

    trait :with_stock do
      stocks { [create(:stock, :stocked)] }
    end

    trait :sku do
      sku_h_item_name 'カラー'
      sku_v_item_name 'サイズ'
      stocks do
        [
          create(:stock, :stocked, sku_h_choice_name: 'レッド', sku_v_choice_name: 'S'),
          create(:stock, :stocked, sku_h_choice_name: 'レッド', sku_v_choice_name: 'M'),
          create(:stock, :stocked, sku_h_choice_name: 'レッド', sku_v_choice_name: 'L')
        ]
      end
    end

    trait :sku_h do
      sku_h_item_name 'カラー'
      stocks { [create(:stock, :stocked, sku_h_choice_name: 'レッド')] }
    end
  end
end
