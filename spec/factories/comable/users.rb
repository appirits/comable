FactoryGirl.define do
  factory :user, class: 'Comable::User' do
    sequence(:email) { |n| "test+#{n}@example.com" }

    trait :with_addresses do
      bill_address { build(:address) }
      ship_address { build(:address) }
    end

    trait :admin do
      role 'admin'
    end
  end
end
