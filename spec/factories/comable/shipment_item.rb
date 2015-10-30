FactoryGirl.define do
  factory :shipment_item, class: Comable::ShipmentItem do
    stock

    trait :with_shipment do
      shpiment
    end
  end
end
