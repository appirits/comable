FactoryGirl.define do
  factory :navigation_item, class: Comable::NavigationItem do
    navigation { build_stubbed(:navigation) }
    name 'navigation_item'
    url 'http://comable.example.com'

    trait :page do
      association :linkable, factory: :page
    end
  end
end
