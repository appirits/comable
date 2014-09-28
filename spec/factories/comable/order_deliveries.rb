FactoryGirl.define do
  factory :order_delivery, class: Comable::OrderDelivery do
    family_name 'hoge'
    first_name 'piyo'
    order { FactoryGirl.build_stubbed(:order) }
  end
end
