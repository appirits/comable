FactoryGirl.define do
  factory :product, class: 'Comable::Product' do
    name 'test_product'
    code '1234567'
    price 100

    trait :many do
      sequence(:name) { |n| "test_product#{n.next}" }
      sequence(:code) { |n| format('%07d', n.next) }
    end

    trait :with_stock do
      stocks { [FactoryGirl.create(:stock, :unsold)] }
    end

    trait :sku do
      sku_h_item_name 'カラー'
      sku_v_item_name 'サイズ'
      stocks do
        [
          FactoryGirl.create(:stock, :unsold, :many, sku_h_choice_name: 'レッド', sku_v_choice_name: 'S'),
          FactoryGirl.create(:stock, :unsold, :many, sku_h_choice_name: 'レッド', sku_v_choice_name: 'M'),
          FactoryGirl.create(:stock, :unsold, :many, sku_h_choice_name: 'レッド', sku_v_choice_name: 'L')
        ]
      end
    end

    trait :sku_h do
      sku_h_item_name 'カラー'
      stocks { [FactoryGirl.create(:stock, :unsold, sku_h_choice_name: 'レッド')] }
    end
  end
end
