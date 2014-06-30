FactoryGirl.define do
  factory :stock, class: 'Comable::Stock' do
    product_id_num 1
    code '1234567-001'
    quantity nil

    trait :with_product do
      comable_product { FactoryGirl.create(:product) }
    end

    trait :soldout do
      quantity 0
    end

    trait :unsold do
      quantity 10
    end

    trait :inavtivated do
      product_id_num nil
    end

    trait :many do
      sequence(:product_id_num) { |n| n.next }
      sequence(:code) { |n| format('%07d', n.next) }
    end
  end
end
