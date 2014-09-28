FactoryGirl.define do
  factory :order_detail, class: Comable::OrderDetail do
    quantity 10
    price 100
    stock { build(:stock, :unsold, :with_product) }
    order_delivery { FactoryGirl.build_stubbed(:order_delivery) }
  end
end
