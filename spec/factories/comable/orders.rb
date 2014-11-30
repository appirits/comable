FactoryGirl.define do
  factory :order, class: Comable::Order do
    email 'test@example.com'
    customer { build(:customer) }
    payment { build(:payment) }

    trait :with_addresses do
      bill_address { build(:address) }
      ship_address { build(:address) }
    end
  end
end
