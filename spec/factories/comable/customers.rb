FactoryGirl.define do
  factory :customer, class: 'Comable::Customer' do
    email 'test@example.com'

    trait :with_addresses do
      bill_address { build(:address) }
      ship_address { build(:address) }
    end
  end
end
