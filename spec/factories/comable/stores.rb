FactoryGirl.define do
  factory :store, class: Comable::Store do
    sequence(:name) { |n| "Test store #{n}" }
  end
end
