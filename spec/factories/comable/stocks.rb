FactoryGirl.define do
  factory :stock, class: 'Comable::Stock' do
    sequence(:code) { |n| format('%07d', n.next) }
    quantity 0
    product { build_stubbed(:product, code: code) }

    transient { sku_flag false }

    trait :sku do
      transient { sku_flag true }
      sku_h_choice_name 'レッド'
      sku_v_choice_name 'S'
      product { build_stubbed(:product, code: code, sku_h_item_name: 'カラー', sku_v_item_name: 'サイズ') }
    end

    trait :with_product do
      after(:create) do |stock, evaluator|
        attributes = { code: stock.code, stocks: [stock] }
        attributes.update(sku_h_item_name: 'カラー', sku_v_item_name: 'サイズ') if evaluator.sku_flag
        create(:product, attributes)
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
