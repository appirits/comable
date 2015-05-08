FactoryGirl.define do
  factory :shipment, class: Comable::Shipment do
    order
    shipment_method
    fee 300
  end
end
