FactoryGirl.define do
  factory :order_detail, class: Comable::OrderDetail do
    quantity 10
    price 100
    stock { FactoryGirl.build_stubbed(:stock) }
    order_delivery { FactoryGirl.build_stubbed(:order_delivery) }
  end
end
