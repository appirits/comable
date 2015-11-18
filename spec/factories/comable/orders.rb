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
    end

    trait :for_confirm do
      state 'confirm'
      bill_address { build(:address) }
      ship_address { build(:address) }
      payment { build(:payment) }
    end

    trait :completed do
      state 'completed'
      bill_address { build(:address) }
      ship_address { build(:address) }
      payment { build(:payment, state: :completed) }

      sequence(:code) { |n| format('%011d', n.next) }
      completed_at Time.now
      total_price 1_000
    end

    trait :with_order_items do
      order_items { [build(:order_item, :in_stock)] }
    end

    trait :with_shipments do
      shipments { [build(:shipment)] }
    end

    trait :draft do
      draft true
      state 'draft'
      bill_address { build(:address) }
      ship_address { build(:address) }
    end

    after(:build) do |order|
      order.shipments.each { |shipment| shipment.state = 'ready' } if order.state? :completed
    end

    # Auto create shipments if shipments are empty.
    after(:create) do |order|
      shipment_phase = order.state?(:shipment) || order.stated?(:shipment)
      order.assign_inventory_units_to_shipments if shipment_phase && order.shipments.empty?
    end
  end
end
