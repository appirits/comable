FactoryGirl.define do
  factory :customer, class: 'Comable::Customer' do
    family_name 'foo'
    first_name 'bar'
    email 'test@example.com'
  end
end
