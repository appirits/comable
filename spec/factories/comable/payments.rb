FactoryGirl.define do
  factory :payment, class: Comable::Payment do
    payment_method
    fee 300

    trait :with_order do
      order
    end
  end
end
