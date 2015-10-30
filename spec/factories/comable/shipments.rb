FactoryGirl.define do
  factory :shipment, class: Comable::Shipment do
    shipment_method
    fee 300

    trait :with_order do
      order
    end
  end
end
