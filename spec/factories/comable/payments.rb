FactoryGirl.define do
  factory :payment, class: Comable::Payment do
    order
    payment_method
    fee 300
  end
end
