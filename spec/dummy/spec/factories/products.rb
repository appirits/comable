FactoryGirl.define do
  factory :product, class: 'Comable::Product' do
    title 'test_product'
    code '1234567'
    price 100

    trait :many do
      sequence(:title) { |n| "test_product#{n.next}" }
      sequence(:code) { |n| format('%07d', n.next) }
    end
  end
end
