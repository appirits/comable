FactoryGirl.define do
  factory :shipment, class: Comable::Shipment do
    order
    shipment_method
    sequence(:name) { |n| "Shipment method ##{n.next}" }
    fee 300
  end
end
