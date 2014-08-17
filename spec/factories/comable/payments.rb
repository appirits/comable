FactoryGirl.define do
  factory :payment, class: Comable::Payment do
    name 'テスト決済'
    payment_method_type 'Comable::PaymentMethod::General'
    payment_method_kind 0
  end
end
