FactoryGirl.define do
  factory :shipment_method, class: Comable::ShipmentMethod do
    name '配送業者名'
    fee 300
  end
end
