FactoryGirl.define do
  factory :category, class: 'Comable::Category' do
    sequence(:name) { |n| "category#{n.next}" }
  end
end
