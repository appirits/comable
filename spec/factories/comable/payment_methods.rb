FactoryGirl.define do
  factory :payment_method, class: Comable::PaymentMethod do
    name 'テスト決済'
    payment_provider_type 'Comable::PaymentProvider::General'
    payment_provider_kind 0
    fee 500
  end
end
