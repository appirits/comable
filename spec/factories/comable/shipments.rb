FactoryGirl.define do
  factory :shipment, class: Comable::Shipment do
    sequence(:name) { |n| "Shipment method ##{n.next}" }
    fee 300
  end
end
