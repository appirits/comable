FactoryGirl.define do
  factory :stock do
    product_id_num 1
    code "1234567-001"
    quantity nil

    trait :soldout do
      quantity 0
    end

    trait :unsold do
      quantity 10
    end

    trait :inavtivated do
      product_id_num nil
    end
  end
end
