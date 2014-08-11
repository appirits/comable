FactoryGirl.define do
  factory :order_delivery, class: Comable::OrderDelivery do
    order { FactoryGirl.build_stubbed(:order) }
  end
end
