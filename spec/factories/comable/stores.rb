FactoryGirl.define do
  factory :store, class: Comable::Store do
    sequence(:name) { |n| "Test store #{n}" }

    trait :email_activate do
      email_sender 'comable@example.com'
    end
  end
end
