FactoryGirl.define do
  factory :product do
    name "test_product"
    code "1234567"
    price 100

    trait :many do
      sequence(:name) {|n| "test_product#{n.next}" }
      sequence(:code) {|n| "%07d" % n.next }
    end
  end
end
