FactoryGirl.define do
  factory :customer, class: 'Comable::Customer' do
    sequence(:email) { |n| "test+#{n}@example.com" }

    trait :with_addresses do
      bill_address { build(:address) }
      ship_address { build(:address) }
    end
  end
end
