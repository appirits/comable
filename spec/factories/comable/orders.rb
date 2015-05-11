FactoryGirl.define do
  factory :order, class: Comable::Order do
    sequence(:email) { |n| "test+#{n}@example.com" }

    trait :with_addresses do
      bill_address { build(:address) }
      ship_address { build(:address) }
    end

    trait :with_user do
      user { build(:user) }
    end

    trait :for_orderer do
      state 'orderer'
    end

    trait :for_delivery do
      state 'delivery'
      bill_address { build(:address) }
    end

    trait :for_shipment do
      state 'shipment'
      bill_address { build(:address) }
      ship_address { build(:address) }
    end

    trait :for_payment do
      state 'payment'
      bill_address { build(:address) }
      ship_address { build(:address) }
      shipment { build(:shipment) }
    end

    trait :for_confirm do
      state 'confirm'
      bill_address { build(:address) }
      ship_address { build(:address) }
      shipment { build(:shipment) }
      payment_method { build(:payment_method) }
    end

    trait :completed do
      state 'complete'
      bill_address { build(:address) }
      ship_address { build(:address) }
      shipment { build(:shipment, state: :ready) }
      payment_method { build(:payment_method) }

      sequence(:code) { |n| format('%011d', n.next) }
      completed_at Time.now
      total_price 1_000
    end
  end
end
